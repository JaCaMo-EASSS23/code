+open_voting(ArtName)
   <- // TODO (Task 2): look up the voting machine by name
      lookupArtifact(ArtName, ArtId);
      // TODO (Task 2): use the artifact ID returned by the lookup operation to focus on the voting machine 
      vm::focus(ArtId)
   .

// This plan is triggered when the status of a voting machine becomes "open". The plan context is used
// to retrieve the voting options, which are exposed via an observable property.
+vm::status("open")[artifact_name(ArtName)] : vm::options(Options)[artifact_name(ArtName)]
   <- .print("New vote started with options: ", Options);
      ?pref_temp(Pref);
      ?closest(Pref, Options, Vote);
      .print("My preference is ", Pref, ", so I vote for ", Vote);
      // TODO (Task 2): invoke vote operation on voting machine artifact
      vm::vote(Vote)
   .

// closest(Pref,Options,V): discovers the Option closser to Pref
closest(P,[H|_],H) :- P <= H. // assuming options are ordered, if the first option is equals of greater than my pref, it is my vote
closest(P,[H1,H2|_],H1) :- P > H1 & P < H2 & P-H1 <= H2-P. // if my preference is between two options, chose the closer
closest(P,[H1,H2|_],H2) :- P > H1 & P < H2 & P-H1 >  H2-P.
closest(P,[H],H). // no more options
closest(P,[_|T],V) :- closest(P,T,V). // keep looking for options in the list

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
