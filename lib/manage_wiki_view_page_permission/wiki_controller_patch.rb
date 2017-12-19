module ManageWikiViewPagePermission
  module WikiControllerPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        before_filter :validate_permission_for_protected_pages, :only=>[:show, :history, :diff, :annotate]
        alias_method_chain :load_pages_for_index, :view_protected_pages_permission
        private

        def validate_permission_for_protected_pages
          deny_access and return if @page.protected? and !User.current.allowed_to?(:view_protected_pages, @project)
        end
      end
    end

    module InstanceMethods
        def load_pages_for_index_with_view_protected_pages_permission
            load_pages_for_index_without_view_protected_pages_permission
            @pages.select!{ |page| page.visible? }
        end
    end
  end
end
