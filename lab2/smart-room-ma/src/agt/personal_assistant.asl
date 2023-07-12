+open_voting(ConvId, TimeOut)[source(Sender)]
   <- ?pref_temp(Pref);
      .print("My preference is ",Pref);
      .send(Sender, tell, pref_temp(ConvId,Pref)).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
