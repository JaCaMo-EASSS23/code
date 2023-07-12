+open_voting(ConvId, Options, TimeOut)[source(Sender)]
   <- ?pref_temp(Pref);
      ?closest(Pref,Options,Vote); // the individual strategy
      .print("My preference is ",Pref," so I vote for ",Vote);
      .send(Sender, tell, vote(ConvId,Vote)).

// closest(Pref,Options,V): discovers the Option closser to Pref
closest(P,[H|_],H) :- P <= H.
closest(P,[H1,H2|_],H1) :- P > H1 & P < H2 & P-H1 <= H2-P.
closest(P,[H1,H2|_],H2) :- P > H1 & P < H2 & P-H1 >  H2-P.
closest(P,[H],H). // no more options
closest(P,[H|T],V) :- closest(P,T,V).


{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
