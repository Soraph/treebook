module ApplicationHelper

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
