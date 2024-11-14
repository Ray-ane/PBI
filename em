def main():
    # Read the Excel file
    excel_file = 'email_list.xlsx'
    try:
        df = pd.read_excel(excel_file)
    except Exception as e:
        print(f"Failed to read Excel file {excel_file}. Error: {e}")
        return

    # Get the current date
    today = datetime.today()
    current_day_name = today.strftime('%A')  # e.g., 'Monday'
    current_day_number = today.day           # e.g., 15

    # Iterate over each row in the DataFrame
    for index, row in df.iterrows():
        report_name = str(row['ReportName'])
        recipient_email = str(row['RecipientEmail'])
        frequency = str(row['Frequency']).strip().lower()

        # Check frequency and decide whether to send the email
        if frequency == 'daily':
            send_email(report_name, recipient_email)
        elif frequency == 'weekly':
            day = str(row['Day']).strip()
            if day.lower() == current_day_name.lower():
                send_email(report_name, recipient_email)
        elif frequency == 'monthly':
            day = int(row['Day'])
            if day == current_day_number:
                send_email(report_name, recipient_email)
        else:
            print(f"Invalid frequency '{frequency}' for report '{report_name}'. Skipping.")
