# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def insert_page_title(title)
    title ||= "Task Notes"
    content_tag(:title, title)
  end
  
  def page_title(title)
    @title = title
  end
end
