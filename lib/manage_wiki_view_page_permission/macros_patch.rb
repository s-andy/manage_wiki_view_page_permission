module ManageWikiViewPagePermission
  module MacrosPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
          alias_method_chain :macro_include, :view_protected_pages_permission
      end
    end

    module InstanceMethods
        def macro_include_with_view_protected_pages_permission(obj, args)
            page = Wiki.find_page(args.first.to_s, :project => @project)
            raise 'Access denied' if !page.nil? && page.protected? && !User.current.allowed_to?(:view_protected_pages, page.wiki.project)
            macro_include_without_view_protected_pages_permission(obj, args)
        end
    end
  end
end
