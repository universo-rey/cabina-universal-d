export interface GovernedTeamsActivity {
  channel: "msteams";
  synthetic: true;
  conversationId: string;
  fromDisplayName: string;
  text: string;
  requestedBy: string;
}
