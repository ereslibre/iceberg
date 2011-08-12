module ApplicationHelper
  def router_text(router)
    res = router.name
    res += " -- #{router.comment}" if router.comment
    res
  end

  def router_text_hash(router)
    res = router[:name]
    res += " -- #{router[:comment]}" if router[:comment]
    res
  end
end
