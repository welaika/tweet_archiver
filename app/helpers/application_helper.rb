module ApplicationHelper
  def i18n_action(action, resource_class)
    I18n.t "helpers.#{action}", :model => I18n.t("activerecord.models.#{resource_class.name.tableize.singularize}")
  end
  def i18n_create(resource_class)
    i18n_action :create, resource_class
  end
  def i18n_index(resource_class)
    i18n_action :index, resource_class
  end
  def i18n_show(resource_class)
    i18n_action :show, resource_class
  end
end
