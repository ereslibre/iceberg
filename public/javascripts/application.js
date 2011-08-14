function fetchRouter(id, command, arguments, password)
{
    new Ajax.Request('/router/' + id + '/' + command + '.js',
    {
        postBody: 'arguments=' + arguments + '&password=' + password
    });
}

var currentStep = 1;
var selectedRouters = null;
var selectedRoutersPass = null;

function fadeCurrentStep()
{
    var step = $('step' + (currentStep - 1));
    if (step) {
        step.fade({duration:0.5, from: 0.5, to: 0.1});
    }
}

function showCurrentStep()
{
    var step = $('step' + (currentStep - 1));
    step.appear({duration:0.5, from: 0.1, to: 0.5 });
}

function fetchNextStep()
{
    var command = null;
    var commandArgs = '';
    if (currentStep == 2) {
        selectedRouters = new Array();
        selectedRoutersPass = new Array();
        var selected = $$('div[selected="true"]');
        if (!selected.length) {
            $('warning').replace('<div id="warning" style="display: none;">Please, select at least one router</div>');
            $('warning').appear({duration:0.5});
            return;
        }
        for (var x = 0; x < selected.length; ++x) {
            selectedRouters[x] = selected[x].getAttribute('id');
            var selectedRouterPass_ = 'router' + selectedRouters[x] + 'password';
            var has_pass = (selected[x].getAttribute('pass') === "true");
            var passValue = $(selectedRouterPass_).getValue();
            if (has_pass && !passValue) {
                $('warning').replace('<div id="warning" style="display: none;">Please, provide a password for all protected routers</div>');
                $('warning').appear({duration:0.5});
                return;
            }
            selectedRoutersPass[x] = passValue;
        }
    } else if (currentStep == 3) {
        command = $$('input:checked[type="radio"][name="action"]').pluck('id');
        commandArgs = $('arguments').getValue();
        var has_args = ($$('input:checked[type="radio"][name="action"]').pluck('value') === "true");
        if (has_args && !commandArgs) {
            $('warning').replace('<div id="warning" style="display: none;">The selected action requires an argument</div>');
            $('warning').appear({duration:0.5});
            return;            
        }
        $('nextbg').fade({duration:0.5});
    }
    $('page').fade({duration:0.5});
    fadeCurrentStep();
    if (currentStep < 3) {
        $('nextbg').fade({duration:0.5});
        $('restart_wizardbg').fade({duration:0.5});
    }
    (function() {
        $('page').replace('<div id="page"><div class="vert_offset"><img src="/images/loading.gif"></div></div>');
        $('page').hide();
        $('page').appear({duration:0.5});
        if (currentStep < 3) {
            new Ajax.Request('/step/' + currentStep + '.js', {
                method: 'get',
                onComplete: function() { $('nextbg').appear({duration:0.5}); }
            });
        } else {
            var routers = selectedRouters.join('&routers[]=');
            var passwords = selectedRoutersPass.join('&pass[]=');
            new Ajax.Request('/routers.js', {
                method: 'post',
                postBody: 'routers[]=' + routers + '&pass[]=' + passwords + '&command=' + command + '&arguments=' + commandArgs
            });
        }
        ++currentStep;
     }).delay(0.5);
}

function fetchFirstStep()
{
    currentStep = 1;
    selectedRouters = null;
    selectedRoutersPass = null;
    var steps = $$('div[class="step"]');
    for (var x = 0; x < steps.length; ++x) {
        steps[x].fade({duration:0.5});
    }
    fetchNextStep();
}

function toggleState(router)
{
    var selected = ($(router).getAttribute('selected') == 'true');
    if (selected) {
        $(router).setAttribute('selected', 'false');
    } else {
        $(router).setAttribute('selected', 'true');
    }
    if ($(router).getAttribute('pass') === "true") {
        var routerPass = 'router' + router + 'pass';
        if (selected) {
            Effect.SlideUp(routerPass, {duration:0.5});
        } else {
            Effect.SlideDown(routerPass, {duration:0.5});
        }
    }
}

function updateArguments()
{
    var has_args = $$('input:checked[type="radio"][name="action"]').pluck('value');
    if (has_args == "true") {
        $('arguments_block').appear({duration:0.5});
    } else {
        $('arguments_block').fade({duration:0.5});
    }
}

document.observe('keypress', function(event) {
    if (event.keyCode == Event.KEY_RETURN) {
        switch (currentStep) {
            case 1:
            case 2:
            case 3:
                fetchNextStep();
                break;
            default:
                fetchFirstStep();
        }
    }
});

document.observe('click', function(e) {
    if (Event.element(e).id != "nextlink") {
        $('warning').fade({duration:0.5});
    }
});
