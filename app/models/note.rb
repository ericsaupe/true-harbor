# frozen_string_literal: true

class Note < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :noteable, polymorphic: true

  after_create_commit do
    table_key = [noteable.class.name.downcase, noteable.id, "notes_feed"].join("_")
    # If this is the first note we need to replace the feed entirely to get rid of the empty state
    if noteable.notes.count == 1
      broadcast_replace_later_to(table_key, target: "notes_container", partial: "notes/feed",
        locals: { noteable: noteable })
    else
      broadcast_prepend_later_to(table_key, partial: "notes/feed_item")
    end
  end

  after_update_commit do
    broadcast_replace_later_to(self, partial: "notes/feed_item")
  end
end
