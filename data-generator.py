import csv

# Open file to write
with open('mocked-data-100000.csv', 'w', newline='') as file:
    writer = csv.writer(file)

    # Write headers
    writer.writerow(['', 'topic_info', 'topic_info', 'topic_info', 'topic_info', 'topic_info'])
    writer.writerow(['', 'topic_id', 'record_number', 'values', 'status', 'reprocess'])

    # Base topic_id
    topic_id = "67503b9591d08f3252054150"

    for i in range(100000):
        # Create row following the pattern
        row = [
            f"{topic_id}:{i}",  # First column
            topic_id,  # topic_id
            i,  # record_number
            f'[{i}, \'000ABC{i}\', {i}]',  # values
            1,  # status
            'False'  # reprocess
        ]
        writer.writerow(row)

print("File generation complete!")