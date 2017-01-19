json.extract! training, :id
json.start training.date
json.end training.date + 1.hour
json.color training.finished? ? 'Green' : 'DarkSalmon'
json.url training_url(training, format: :html)
