class RouterController < ApplicationController
  def index
    router_list = nil
    router_pass = nil
    if SHOW_ROUTER_LIST and params.has_key? :routers
      router_list = params[:routers]
    elsif not SHOW_ROUTER_LIST
      router_list = [DEFAULT_ROUTER_ID]
    end
    if params.has_key? :pass
      router_pass = params[:pass]
    else
      router_pass = nil
    end
    i = -1
    @routers = router_list ?
                 Router.find(router_list).collect { |router|
                   i += 1
                   { :id              => router.id,
                     :name            => router.name,
                     :comment         => router.comment,
                     :password        => router_pass[i],
                     :server          => router.server,
                     :port            => router.port,
                     :router_username => router.router_username,
                     :router_password => router.router_password }
                 } : nil
  end

  def show
    @router_id = params[:id]
    @router_command = params[:command]
    @router_password = params[:password]
    if SHOW_ROUTER_LIST or DEFAULT_ROUTER_ID == @router_id.to_i
      @router = Router.find @router_id
      if @router.password == nil or @router.password.empty? or @router.password == @router_password
        if Permission.exists? :router_id => @router_id, :command_id => @router_command
          if CommandSet.exists? :command_id => @router_command, :model_id => @router.model_id
            command_ = Command.find(@router_command)
            command = CommandSet.find_by_command_id_and_model_id(@router_command, @router.model_id)
            arguments = params[:arguments]
            validated = true
            if arguments and command_.arguments_validation
              validated = (/#{command_.arguments_validation}/.match(arguments) != nil)
            end
            if validated
              adapted_command = adapt_command command.command_line, arguments
              ROUTER_SESSIONS[@router_id] = ROUTER_SESSIONS.has_key?(@router_id) ?
                                            ROUTER_SESSIONS[@router_id] + 1 : 1
              if ROUTER_SESSIONS[@router_id] > @router.max_sessions
                @res = { :status => ROUTER_OVERLOADED }
              else
                @res = send_command(@router.server,
                                    @router.port,
                                    @router.router_username,
                                    @router.router_password,
                                    adapted_command)
                if @res
                  @res = { :status => SUCCESS, :result => @res.gsub!(/\r\n?/, "\n").gsub!(/^( +)/){ |m| m.gsub(' ', '&nbsp;') } }
                else
                  @res = { :status => SSH_ERROR }
                end
              end
              ROUTER_SESSIONS[@router_id] -= 1
            else
              @res = { :status => INVALID_ARGUMENTS }
            end
          else
            @res = { :status => MISSING_COMMAND }
          end
        else
          @res = { :status => PERMISSION_ERROR }
        end
      else
        @res = { :status => INCORRECT_PASSWORD }
      end
    else
      @res = { :status => INVALID_ROUTER }
    end
  end

  # Helpers

  def send_command(host, port, user, password, command)
    begin
      Net::SSH.start(host, user, :password => password, :port => port) do |ssh|
        return ssh.exec!(command)
      end
    rescue Exception
      return nil
    end
  end

  def adapt_command(command, arguments)
    command.gsub! /%a%/, arguments
    command
  end
end
