json.(evaluation, :id, :lecture_id, :comment, :score, :easiness, :grading)
json.can_update can?(:update, evaluation)
json.can_destroy can?(:destroy, evaluation)
