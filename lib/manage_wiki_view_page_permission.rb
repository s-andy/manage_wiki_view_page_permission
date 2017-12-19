module ManageWikiViewPagePermission
  def self.apply_patch
    WikiController.send(:include, ManageWikiViewPagePermission::WikiControllerPatch)
    WikiPage.send(:include, ManageWikiViewPagePermission::WikiPagePatch)
    Redmine::WikiFormatting::Macros::Definitions.send(:include, ManageWikiViewPagePermission::MacrosPatch)
  end
end
