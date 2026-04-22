enum TicketStatus {
  open('Open'),
  pending('Pending'),
  resolved('Resolved'),
  closed('Closed'),
  inProgress('In Progress');

  final String label;
  const TicketStatus(this.label);
}

enum TicketPriority {
  low('Low'),
  medium('Medium'),
  high('High'),
  urgent('Urgent');

  final String label;
  const TicketPriority(this.label);
}