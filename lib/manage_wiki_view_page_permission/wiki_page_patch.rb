module ManageWikiViewPagePermission
  module WikiPagePatch
    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
      base.class_eval do
          alias_method_chain :visible?, :view_protected_pages_permission
          class << self
            alias_method_chain :search_scope, :view_protected_pages_permission
          end
      end
    end

    module ClassMethods
        def search_scope_with_view_protected_pages_permission(user, projects, options={})
            scope = search_scope_without_view_protected_pages_permission(user, projects, options)
            scope.where("#{WikiPage.table_name}.protected = ? OR (#{Project.allowed_to_condition(user, :view_protected_pages)})", false)
        end
    end

    module InstanceMethods
        def visible_with_view_protected_pages_permission?(user=User.current)
            visible_without_view_protected_pages_permission?(user) and (!protected? or user.allowed_to?(:view_protected_pages, project))
        end
    end
  end
end
