module ApplicationHelper

  # To change the default form builder to my custom one
  #ActionView::Base.default_form_builder = BoostrapFormBuilder

  def can_display_status?(status) 
    signed_in? && !current_user.has_blocked?(status.user) || !signed_in?
  end

  def flash_css_class(type)
    case type
    when :alert
      "alert-warning"
    when :notice
      "alert-info"
    when :success
      "alert-success"
    when :error
      "alert-danger"
    else
      ""
    end
  end
end

class BoostrapFormBuilder < ActionView::Helpers::FormBuilder
  def text_field(method, options = {})
    options[:class] ||= ""
    options[:label] ||= "#{method.to_s}".humanize

    @template.content_tag :div, class: "form-group #{ 'has-error' unless @object.errors[method].blank?}" do
      @template.label_tag("#{object_name}[#{method}]", "#{options[:label]}", :class => "control-label") +
      @template.text_field_tag("#{object_name}[#{method}]", nil, :class => "form-control #{options[:class]}") 
    end
  end

  def email_field(method, options = {})
    options[:class] ||= ""
    options[:label] ||= "#{method.to_s}".humanize

    @template.content_tag :div, class: "form-group #{ 'has-error' unless @object.errors[method].blank?}" do
      @template.label_tag("#{object_name}[#{method}]", "#{options[:label]}", :class => "control-label") +
      @template.email_field_tag("#{object_name}[#{method}]", nil, :class => "form-control #{options[:class]}") 
    end
  end

  def password_field(method, options = {})
    options[:class] ||= ""
    options[:label] ||= "#{method.to_s}".humanize

    @template.content_tag :div, class: "form-group #{ 'has-error' unless @object.errors[method].blank?}" do
      @template.label_tag("#{object_name}[#{method}]", "#{options[:label]}", :class => "control-label") +
      @template.password_field_tag("#{object_name}[#{method}]", nil, :class => "form-control #{options[:class]}") 
    end
  end
end