!voting. // agent initial goal

+!voting
   <- !open_voting(Id);
      !wait_votes(Id);
      !close_voting(Id).

+!open_voting(Id)
   <- Id = 1;
      .broadcast(tell, open_voting(Id,[21,25,30],4000)).

+!wait_votes(Id) <- .wait(all_votes_received(Id), 4000, _).

all_votes_received(ConvId)
  :- .count(vote(ConvId,_), 3).    // equals number of votes


+!close_voting(Id)
   <- ?most_voted(T);
      .println("New goal to set temperature to ",T);
      .broadcast(tell, close_voting(Id,T));
      !temperature(T);
   .
most_voted(T)
   :- T = 20.


tolerance(2). // used in temp_management
{ include("temp_management.asl") }

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
