import { routeTeamsActivity } from "./sduRouter";
import { assertGovernedActivity } from "./governance";

export async function handleActivity(activity: unknown) {
  const governed = assertGovernedActivity(activity);
  return routeTeamsActivity(governed);
}
