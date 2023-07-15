package voting;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import cartago.ARTIFACT_INFO;
import cartago.Artifact;
import cartago.INTERNAL_OPERATION;
import cartago.OPERATION;
import cartago.OUTPORT;
import cartago.OperationException;
import jason.asSyntax.ASSyntax;
import jason.asSyntax.ListTerm;
import jason.asSyntax.parser.ParseException;

@ARTIFACT_INFO(
  outports = {
    @OUTPORT(name = "dweet")
  }
)
public class VotingMachine extends Artifact {
  private List<String> voters;
  private List<Integer> votes;
  private int deadline;

  public void init() {
    // Task 1: define a status property with values open/closed
    defineObsProperty("status", "closed");
  }

  @OPERATION
  public void open(Object[] options, Object[] voters, int deadline) {
    this.voters = new ArrayList<>();
    this.votes = new ArrayList<>();
    this.deadline = deadline;

    ListTerm optionTerms = createOptionTermsList(options);

    for (Object v: voters) {
      this.voters.add(v.toString());
    }

    // Task 1: expose the options as an observable property named "options"
    defineObsProperty("options", optionTerms);
    // Task 1: expose the deadline as an observable property named "deadline"
    defineObsProperty("deadline", this.deadline);
    // Task 1: update the "status" observable property to "open" to announce that voting is open
    getObsProperty("status").updateValue("open");

    // execInternalOp("countdown");
  }

  @OPERATION
  public void vote(int vote) {
    // Checks that voting is open — and throws a failure if not
    if (getObsProperty("status").getValue().equals("close")) {
      failed("The voting machine is closed!");
    }

    // Checks if the agent invoking the operation has already voted
    if (voters.remove(getCurrentOpAgentId().getAgentName())) {
      // If not, then accept the vote
      votes.add((Integer) vote);
    } else {
      // Otherwise, throw a failure
      failed("You've already voted!");
    }
  }

  @OPERATION
  public void close() {
    int result = computeResult();

    // Task 1: expose the result as an observable property named "result"
    defineObsProperty("result", result);
    // Task 1: update the "status" observable property to "close" to announce that voting is closed
    getObsProperty("status").updateValue("closed");

    try {
      log("Publishing the result to dweet.io: " + result);
      // Task 4: invoke the "dweet" linked operation and pass the result as a paramteter
      execLinkedOp("dweet", "dweet", String.valueOf(result));
    } catch (OperationException e) {
      log("Failed to publish the result: " + e.getMessage());
    }
  }

  // Task 3: implement an internal operation with a countdown. The internal operation should be
  // invoked at the end of the open() operation.
  @INTERNAL_OPERATION
  private void countdown() {
    await_time(deadline);
    log("Voting is closing!");
    close();
  }

  // This method is used to convert datum from Jason to Java
  private ListTerm createOptionTermsList(Object[] options) {
    ListTerm optionTerms = ASSyntax.createList();

    for (Object o: options) {
      try {
        optionTerms.add(ASSyntax.parseTerm(o.toString()));
      } catch (ParseException e) {
        log(e.getMessage());
      }
    }

    return optionTerms;
  }

  // This method is used to compute the winner
  private int computeResult() {
    // Aggregate the votes
    Map<Integer, Long> counts = votes.stream().collect(Collectors.groupingBy(x -> x, Collectors.counting()));
    // Returns the option with most votes
    Integer result = Collections.max(counts.entrySet(), Map.Entry.comparingByValue()).getKey();

    return result;
  }
}
