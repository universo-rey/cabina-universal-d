import type { GovernedTeamsActivity } from "./types";

export function assertGovernedActivity(activity: unknown): GovernedTeamsActivity {
  const candidate = activity as Partial<GovernedTeamsActivity>;
  if (!candidate || candidate.channel !== "msteams" || candidate.synthetic !== true) {
    throw new Error("SDU Teams bot DEV scaffold accepts synthetic Teams activity only");
  }
  if (!candidate.text || candidate.text.length > 1200) {
    throw new Error("Synthetic activity text is required and bounded");
  }
  return candidate as GovernedTeamsActivity;
}
