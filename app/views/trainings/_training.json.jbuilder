json.extract! training, :id
json.start training.date
json.end training.date + 1.hour
json.color training.date > DateTime.current ? 'DarkSalmon' : 'Green'
json.url training_url(training, format: :html)
