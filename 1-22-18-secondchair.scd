//s.options.outDevice = "JackRouter";
s.boot;

(
SynthDef(\sinetest,{
	arg out=0,amp=0.5,rel=0.5,freq=440,pan=0,modFreq=1;
	var sig,env;
	env = Env.perc(0.01,rel,1,-6).kr(2);
	sig = SinOsc.ar(freq);
	sig = sig * env;
	sig = Pan2.ar(sig,pan,amp * SinOsc.kr(modFreq).range(0,1));
	sig = sig.tanh;

	Out.ar(out,sig);
}).add;

(
SynthDef(\pmtest,{
	arg out=0,amp=0.5,rel=0.5,freq=440,pan=0,ratio=1,index = 1,atk=0.01;
	var sig,env,mod;
	mod = freq * ratio;
	env = Env.perc(atk,rel,1,-6).kr(2);
	sig = PMOsc.ar(freq,mod,index);
	sig = sig * env;
	sig = Pan2.ar(sig,pan,amp);
	sig = sig.tanh;

	Out.ar(out,sig);
}).add;)
)

p = ProxySpace.push;
p.makeTempoClock;
p.clock.tempo = 60/60;

(
~sinepat.play;
~sinepat.quant = 4;
~sinepat.fadeTime_(4.0);

//Me *trying* to be Brian Eno
~sinepat = Pbind(
	\instrument, \sinetest,
	\dur,Pwrand([1/4,1/2,1],[2,1,0.25].normalizeSum,inf),
	\freq,Pwrand([Prand((60,120..600).round(60),1)*
		Prand([1,2,3],1)*Pwrand([0.01,0.998,0.0122,0.993,1],[1,2,1,2,4].normalizeSum,1),\rest],[0.35,0.65],inf),
	//\out,d,
	\amp,Prand((0.1,0.2..0.3),inf),
	\rel,Pwhite(1,8.0,inf),
	\pan,Pwhite(0.1,1.0,inf),
	\modFreq, Pwhite(1,14.0,inf),);
(
(~reverb = {arg mix = 0.7, room = 1, dFreq = 10;
	var damp;
	damp = LFNoise1.kr(dFreq).range(0,1);
	FreeVerb.ar(~sinepat,mix,room,damp)};);
~reverb.fadeTime_(4.0);
~reverb.play;)
)

//You ready for some synth clarinet!
(
~pmpat.fadeTime_(4.0);
~pmpat.quant = 4;
~pmpat.play;
~pmpat = Pbind(
	\instrument, \pmtest,
	\dur,Pwrand([1/4,1/2,1,1/8],[2,1,0.25,1].normalizeSum,inf),
	\freq,Pwrand([Prand((60,120..300).round(60),1)*
		Prand([1,2,0.5],1)*Pwrand([0.01,0.998,0.0122,0.993,1],[1,2,1,2,4].normalizeSum,1),\rest],[0.4,0.6],inf),
	//\out,d,
	\amp,Pwrand([0.08,0.06,0.05],[3,4,2].normalizeSum,inf),
	\rel,Pwrand([(Pwhite(1,8.0,1)),6.0,4.0],[1,2,3].normalizeSum,inf),
	\atk,Prand([0.1,1,2,3],inf),
	\pan,Pwhite(0.1,1.0,inf),
	\ratio, Pwhite(1,2,inf),
	\index, Pxrand((1..3),inf),
);
)

//Evaluate when you've had enough
(
~pmpat.clear(10);
~sinepat.clear(10);
~reverb.clear(10);
)

