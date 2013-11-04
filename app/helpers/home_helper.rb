module HomeHelper
  class CommonHelper
    def calculate_skip_number_in_pagination page_param, total_obj_per_page
      ((calculate_page page_param) - 1)*total_obj_per_page
    end

    def calculate_page page_param
      page = 1
      if page_param and page_param.to_i > 1
        page = page_param.to_i
      end

      page
    end
  end

end
