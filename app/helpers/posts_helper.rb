module PostsHelper
  def display_conditions(conditions)
    display_parts = conditions.compact.map { |label, value| "#{label}: #{value}" }
    display_parts.any? ? display_parts.join(', ') : nil
  end

  def condition(label, value)
    [label, value] if value.present?
  end

  def display_age_group_label
    age_group_key = @q.age_group_eq.present? ? Post.age_groups.key(@q.age_group_eq) : nil
    age_group_key.present? ? I18n.t("enums.post.age_group.#{age_group_key}") : nil
  end
end
