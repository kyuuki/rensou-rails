json.array!(@rensous) do |rensou|
  json.extract! rensou, :id, :user_id, :keyword, :old_keyword, :favorite, :created_at
end
