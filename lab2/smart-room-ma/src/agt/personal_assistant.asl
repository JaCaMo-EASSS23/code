+open_voting(ConvId, Options, TimeOut)[source(Sender)]
   <- //?pref_temp(Pref);
      [Pref|_] = Options;
      .print("My preference is ",Pref);
      .send(Sender, tell, vote(ConvId,Pref)).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
