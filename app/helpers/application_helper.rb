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

  FORM_HELPERS = %w{text_field password_field email_field}

  delegate :content_tag, to: :@template
  delegate :label_tag, to: :@template

  def standard_html(type, method, options = {})
    options[:class] ||= ""
    options[:label] ||= "#{method.to_s}".humanize
    content_tag :div, class: "form-group #{ 'has-error' unless @object.errors[method].blank?}" do
      label_tag("#{object_name}[#{method}]", "#{options[:label]}", :class => "control-label") +
      @template.send(type+'_tag', "#{object_name}[#{method}]", nil, :class => "form-control #{options[:class]}")
    end
  end

  FORM_HELPERS.each do |method_name|
    define_method(method_name) do |method, *args|
      options = args.extract_options!.symbolize_keys!
      standard_html("#{__method__.to_s}", method, options)
    end
  end
end