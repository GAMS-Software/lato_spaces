module LatoSpaces::Associable
  extend ActiveSupport::Concern

  included do
    # Relations
    ##

    has_many :lato_spaces_associations, class_name: 'LatoSpaces::Association', as: :item, dependent: :destroy
    has_many :lato_spaces_groups, through: :lato_spaces_associations, class_name: 'LatoSpaces::Group'

    # Scopes
    ##

    scope :for_lato_spaces_group, -> (group_id) { joins(:lato_spaces_groups).where(lato_spaces_groups: { id: group_id }) }
    scope :with_lato_spaces_groups, -> { joins(:lato_spaces_groups) }
    scope :without_lato_spaces_groups, -> { left_outer_joins(:lato_spaces_groups).where(lato_spaces_groups: { id: nil }) }
  end

  def add_to_group(group_id)
    association = lato_spaces_associations.create(lato_spaces_group_id: group_id)
    unless association.valid?
      errors.add(:base, association.errors.full_messages.join(', '))
      return false
    end

    true
  end

  def remove_from_group(group_id)
    association = lato_spaces_associations.find_by(lato_spaces_group_id: group_id)
    return true unless association

    unless association.destroy
      errors.add(:base, association.errors.full_messages.join(', '))
      return false
    end

    true
  end

  def switch_group(group_id)
    association = lato_spaces_associations.first
    return add_to_group(group_id) unless association

    unless association.update(lato_spaces_group_id: group_id)
      errors.add(:base, association.errors.full_messages.join(', '))
      return false
    end

    true
  end 
end
