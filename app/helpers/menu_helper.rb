# frozen_string_literal: true

module MenuHelper
  def desktop_menu_classes(controller:)
    params[:controller] == controller ? active_desktop_menu_classes : inactive_desktop_menu_classes
  end

  def active_desktop_menu_classes
    "bg-white text-gray-900 group flex items-center px-2 py-2 text-sm font-medium rounded-md"
  end

  def inactive_desktop_menu_classes
    ["text-gray-600",
     "hover:bg-white",
     "hover:text-gray-900",
     "group",
     "flex",
     "items-center",
     "px-2",
     "py-2",
     "text-sm",
     "font-medium",
     "rounded-md",].join(" ")
  end

  def mobile_menu_classes(controller:)
    params[:controller] == controller ? active_mobile_menu_classes : inactive_mobile_menu_classes
  end

  def active_mobile_menu_classes
    "bg-white text-gray-900 group flex items-center px-2 py-2 text-base font-medium rounded-md"
  end

  def inactive_mobile_menu_classes
    ["text-gray-600",
     "hover:bg-white",
     "hover:text-gray-900",
     "group",
     "flex",
     "items-center",
     "px-2",
     "py-2",
     "text-base",
     "font-medium",
     "rounded-md",].join(" ")
  end
end
