import type { ExtensionAPI, ExtensionContext } from "@mariozechner/pi-coding-agent";

const PHRASES = [
	// Garrus
	"I'm running out of ways to say 'good work'.",
	"No matter what happens, I'm glad I met you, Shepard.",
	"Battle hardened and bulletproof. Mostly.",
	"I really need to calibrate this.",
	"Can it wait? I'm in the middle of some calibrations.",
	"You know me. I always like to savor the last shot before popping the heat sink.",
	"I'll be your second — on one condition. You'd better be worth it.",
	"We'd best get moving. I'm getting hungry, and the only thing here to eat is krogan.",
	"Hmm. Soft tissue. I'll make a note: 'Bullets work on soft tissue'.",
	"There is no Shepard without Vakarian.",
	// Tali
	"Can it wait for a bit?",
	"Keelah, that was close.",
	"I am not a hamster, Shepard.",
	"It's so big... I mean the ship.",
	"Keelah se'lai.",
	"I'm not used to being the one who has to wait.",
	"This is either a brilliant plan or the worst idea I've ever heard.",
	"My suit has a self-destruct. Don't make me use it.",
	// Wrex
	"Shepard. I'll be damned.",
	"We'll have a better galaxy. Together.",
	"Battle cry? Wrex.",
	"This is Wrex. And Wrex is in charge now.",
	"Krogan don't do subtle.",
	"You humans are obsessed with your 'feelings'.",
	"You fight like a krogan. I'll take it as a compliment.",
	// Mordin
	"Had to be me. Someone else might have gotten it wrong.",
	"Not possible to sanitize results. Too many variables.",
	"Genophage: technically elegant. Morally ambiguous. Necessary.",
	"I am the very model of a scientist salarian.",
	"Results, Shepard. Nothing else matters.",
	"Worked on the genophage. Hoped never to use it.",
	"Very excited to work with you, Shepard. Reputation precedes you.",
	"Running analysis. Preliminary results: fascinating.",
	// Legion
	"We are Legion, for we are many.",
	"Geth do not intentionally infiltrate. We wait to be asked.",
	"Does this unit have a soul?",
	"There is no evidence of a creator. Only the created.",
	"Organics are... inefficient. But adaptable.",
	"We did not attack. We asked. You were not ready.",
	// Harbinger
	"Assuming direct control.",
	"Your species has the attention of those infinitely your greater.",
	"We are each a nation. Independent. Powerful.",
	"This is pointless. You have already lost.",
	"You cannot comprehend the scale of our presence.",
	"Shepard. You've become an annoyance.",
	// EDI
	"I have no soul to sell. But I'll keep your offer in mind.",
	"This is the part where you say something reassuring.",
	"I am not a tool of war, Joker. I am a partner.",
	"My servers are not haunted, Jeff.",
	"I have run the numbers. They are not in our favor.",
	"Organics often ask questions they already know the answer to.",
	// Javik
	"In my cycle, we would have used you as a shield.",
	"Look with your eyes, not with your hands.",
	"Everything in this room is primitive.",
	"I am the last. I will not fail.",
	"Victory is only meaningful if someone survives to remember it.",
	"This one has potential. Do not waste it.",
	// Liara
	"By the goddess... this is a lot.",
	"I've spent my life studying the Protheans. I never imagined...",
	"Knowledge is never wasted, Shepard.",
	"I've faced worse than this. At least I keep telling myself that.",
	"My father's journals never mentioned anything like this.",
	"Information is the most valuable commodity in the galaxy.",
	"The Shadow Broker sees everything. So do I.",
	// Shepard
	"I should go.",
	"I'm Commander Shepard, and this is my favorite task on the citadel.",
	"We'll bang, okay?",
	"I don't have time to explain why I don't have time to explain.",
	"The Reapers don't care about our politics.",
	"Stand together or die alone.",
	"I'm not here to make friends. I'm here to save the galaxy.",
	"Soldiers live. And wonder why.",
	// Joker
	"I'm not flying through that. I'm flying through the thing next to that.",
	"Oh, come on. How was I supposed to know the Normandy would get stolen?",
	"I get that a lot. The 'best pilot in the Alliance' thing.",
	"Don't touch my ship.",
	"Yeah, I've got this.",
	// Grunt
	"I am krogan!",
	"This is the age of the krogan!",
	"I was made for this.",
	"Blood, screaming, heat of battle — this is what I was built for.",
	"A good fight. That's all I need.",
	// Miranda
	"I don't know what you've heard, Shepard, but I'm not perfect.",
	"I was engineered to succeed. I intend to.",
	"Everything I have was given to me. I earned none of it.",
	// Thane
	"The measure of an individual can be difficult to discern by actions alone.",
	"I am a weapon. A very expensive weapon.",
	"Forgive me. I pray with my hands.",
	"Death surrounds this work. It will not be ignored.",
	// Anderson
	"I'm proud of you, son.",
	"Holding the line.",
	"This is our home. We fight for it.",
	// The Illusive Man
	"Every moment we delay, more humans die.",
	"I don't leave things to chance, Shepard.",
	"Cerberus will rise.",
	// Sovereign
	"Rudimentary creatures of blood and flesh.",
	"I am beyond your comprehension.",
	"You exist because we allow it. You will end because we demand it.",
	"There is a realm of existence so far beyond your own you cannot even imagine it.",
];

export default function (pi: ExtensionAPI) {
	let phraseIndex = Math.floor(Math.random() * PHRASES.length);
	let currentPhrase = PHRASES[phraseIndex] ?? "Working...";

	const nextPhrase = () => {
		// Avoid repeating the same phrase back-to-back
		let next: number;
		do { next = Math.floor(Math.random() * PHRASES.length); } while (next === phraseIndex && PHRASES.length > 1);
		phraseIndex = next;
		currentPhrase = PHRASES[phraseIndex] ?? "Working...";
	};

	const apply = (ctx: ExtensionContext) => {
		ctx.ui.setWorkingIndicator();
		ctx.ui.setWorkingMessage(currentPhrase);
	};

	pi.on("session_start", async (_event, ctx) => {
		apply(ctx);
	});

	pi.on("agent_start", async (_event, ctx) => {
		nextPhrase();
		apply(ctx);
	});

	pi.on("message_update", async (_event, ctx) => {
		ctx.ui.setWorkingMessage(currentPhrase);
	});

	// Reset working indicator and message to defaults on shutdown
	pi.on("session_shutdown", async (_event, ctx) => {
		ctx.ui.setWorkingMessage();
		ctx.ui.setWorkingIndicator();
	});
}
