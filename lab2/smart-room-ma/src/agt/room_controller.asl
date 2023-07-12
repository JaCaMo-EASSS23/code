all_pref_received(ConvId)
  :- .count(pref_temp(ConvId,_), 3).    // equals number of votes

average_pt(ConvId,T) :- .findall(UT, pref_temp(ConvId,UT), LT) &
              LT \== [] &
              T = math.average(LT).

!voting. // agent initial goal

+!voting
   <- !open_voting(Id);
      !wait_votes(Id);
      !close_voting(Id).

+!open_voting(Id)
   <- Id = 1;
      .broadcast(tell, open_voting(Id,4000)).

+!wait_votes(Id) <- .wait(all_pref_received(Id), 4000, _).

+!close_voting(Id)
   <- ?average_pt(Id,T);
      .println("New goal to set temperature to ",T);
      .broadcast(tell, close_voting(Id,T));
      !temperature(T);
   .

tolerance(2). // used in temp_management
{ include("temp_management.asl") }

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
