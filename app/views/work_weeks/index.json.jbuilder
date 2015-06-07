json.array!(@work_weeks) do |work_week|
  json.extract! work_week, :id, :started_at, :ended_at, :notes, :hours, :invoice_id
  json.url work_week_url(work_week, format: :json)
end
