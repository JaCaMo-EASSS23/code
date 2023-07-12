conv_id(1).

all_pref_received(ConvId)
  :- .all_names(L) & .length(L,NP) &               // number of voters
     .count(pref_temp(ConvId,_)[source(_)], NP-1).    // equals number of votes

average_pt(ConvId,T) :- .findall(UT, pref_temp(ConvId,UT), LT) &
              LT \== [] &
              T = math.average(LT).

!voting.

+!voting
   <- !open_voting(Id);
      !wait_votes(Id);
      !close_voting(Id).

+!open_voting(Id)
   <- !get_id(Id);
      .broadcast(tell, open_voting(Id,4000)).

@lId[atomic]
+!get_id(ConvId) : conv_id(ConvId)  <- -+conv_id(ConvId+1).

+!wait_votes(Id) <- .wait(all_pref_received(Id), 4000, _).

+!close_voting(Id)
   <- ?average_pt(Id,T);
      .println("New goal to set temperature to ",T);
      .broadcast(tell, close_voting(Id,T));
      .drop_desire(temperature(_));
      !temperature(T);
   .

tolerance(2). // used in temp_management
{ include("temp_management.asl") }

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
