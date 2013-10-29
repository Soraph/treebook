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

  def prepare_options(method, options)
    options[:class] ||= ""
    options[:label] ||= "#{method.to_s}".humanize
    options
  end

  def standard_html(type, method, options = {})
    prepare_options(method, options)
    @template.content_tag :div, class: "form-group #{ 'has-error' unless @object.errors[method].blank?}" do
      @template.label_tag("#{object_name}[#{method}]", "#{options[:label]}", :class => "control-label") +
      case type
      when 'text'
        @template.text_field_tag("#{object_name}[#{method}]", nil, :class => "form-control #{options[:class]}")
      when 'email'
        @template.email_field_tag("#{object_name}[#{method}]", nil, :class => "form-control #{options[:class]}") 
      when 'password'
        @template.password_field_tag("#{object_name}[#{method}]", nil, :class => "form-control #{options[:class]}")
      end
    end
  end

  def text_field(method, options = {})
    standard_html('text', method, options)
  end

  def email_field(method, options = {})
    standard_html('email', method, options)
  end

  def password_field(method, options = {})
    standard_html('password', method, options)
  end
end