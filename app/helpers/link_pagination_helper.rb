module LinkPaginationHelper
  class LinkRenderer < WillPaginate::ActionView::LinkRenderer

    protected
      def html_container(html)
        tag :nav, tag(:ul, html, class: ul_class)
      end

      def page_number(page)
        item_class = if(page == current_page)
          'active page-item'
        else
          'page-item'
        end

        tag :li, link(page, page, :rel => rel_value(page), :class => 'page-link btn-outline-base'), :class => item_class
      end

      def gap
        tag :li, link('&hellip;'.html_safe, '#', :class => 'page-link btn-outline-base'), :class => 'page-item disabled'
      end

      def previous_or_next_page(page, text, classname)
        tag :li, link(text, page || '#', :class => 'page-link btn-outline-base'), :class => [(classname[0..3] if  @options[:page_links]), (classname if @options[:page_links]), ('disabled' unless page), 'page-item'].join(' ')
      end

      def ul_class
         ["pagination", container_attributes[:class]].compact.join(" ")
      end
  end
end