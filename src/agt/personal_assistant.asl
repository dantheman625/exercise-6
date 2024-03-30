// personal assistant agent

/* Initial goals */ 

// The agent has the goal to start
!start.

natural_light(0).
artificial_light(1).


best_option(Option) :- Option = 0.

/* 
 * Plan for reacting to the addition of the goal !start
 * Triggering event: addition of goal !start
 * Context: true (the plan is always applicable)
 * Body: greets the user
*/
@start_plan
+!start : true <-
    .print("Hello world");
    !setupArtifacts(Dweeter).

+!setupArtifacts(Dweeter) : true <-
    makeArtifact("dweeter", "room.DweetArtifact", [], Dweeter).


+blinds(State) : true <-
    .print("Blinds are ", State).

+lights(State) : true <-
    .print("Lights are ", State).

+upcoming_event("now") : owner_state("awake") <-
    .print("Enjoy your event!").

+upcoming_event("now") : owner_state("asleep") <-
    .print("Start wake-up routine");
    !wake_up_owner.

+owner_state("asleep") : upcoming_event("now") <-
    .print("Start wake-up routine");
    !wake_up_owner.

+owner_state("awake") : upcoming_event("now") <-
    .print("Enjoy your event!").

+!wake_up_owner : true <-
    .abolish(propose(_));
    .abolish(refuse(_));
    .broadcast(achieve, increase_illuminance);
    .wait(2000);
    !select_wake_up_option.

+!select_wake_up_option : true <-
    if (propose("natural_light")) {
        .print("choosing natural_light");
        .send(blinds_controller, achieve, raise_blinds);
        .abolish(owner_state(_));
    } elif (propose("artificial_light")) {
        .print("choosing artificial_light");
        .send(lights_controller, achieve, turn_on_lights);
        .abolish(owner_state(_));
    } else {
        .print("All options refused. Informing Jane");
        sendDweet("Jane", "tell", "wake_up_owner");
        .abolish(owner_state(_));
    }.



/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }