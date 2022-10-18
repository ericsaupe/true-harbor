# frozen_string_literal: true

module ApplicationHelper
  def flash_class(type)
    case type.to_s
    when "success"
      "bg-emerald-600"
    when "error"
      "bg-red-600"
    when "warning"
      "bg-yellow-600"
    when "notice" # devise uses this
      "bg-emerald-600"
    else
      "bg-pink-600 #{type}"
    end
  end

  # This method creates a link with `data-id` `data-fields` attributes. These attributes are used to create new
  # instances of the nested fields through Stimulus.
  def link_to_add_fields(name, form, association)
    new_object = form.object.send(association).klass.new
    id = new_object.object_id

    fields = form.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", form: builder)
    end

    button_tag(name, type: "button",
      class: "inline-flex items-center rounded-md border border-gray-300 bg-white px-3 py-2 text-sm font-medium
        leading-4 text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-pink-500
        focus:ring-offset-2",
      data: { id: id, fields: fields.gsub("\n", ""), action: "nested-fields#addChild" })
  end
end
