json.extract! training, :id
json.start training.date
json.end training.date + 1.hour
json.color 'DarkSalmon'
json.url training_url(training, format: :html)
