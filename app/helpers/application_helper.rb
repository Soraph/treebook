module ApplicationHelper

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
