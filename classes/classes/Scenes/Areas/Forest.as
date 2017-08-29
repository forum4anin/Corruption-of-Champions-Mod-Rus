/**
 * Created by aimozg on 06.01.14.
 */
package classes.Scenes.Areas
{
	import classes.*;
	import classes.GlobalFlags.kFLAGS;
	import classes.GlobalFlags.kGAMECLASS;
import classes.Scenes.API.Encounter;
import classes.Scenes.API.Encounters;
import classes.Scenes.API.FnHelpers;
	import classes.Scenes.API.IExplorable;
	import classes.Scenes.Areas.Forest.*;
	
	use namespace kGAMECLASS;

	public class Forest extends BaseContent implements IExplorable
	{
		public var akbalScene:AkbalScene = new AkbalScene();
		public var beeGirlScene:BeeGirlScene = new BeeGirlScene();
		public var corruptedGlade:CorruptedGlade = new CorruptedGlade();
		public var essrayle:Essrayle = new Essrayle();
		public var faerie:Faerie = new Faerie();
		public var kitsuneScene:KitsuneScene = new KitsuneScene();
		public var tamaniScene:TamaniScene = new TamaniScene();
		public var tentacleBeastScene:TentacleBeastScene = new TentacleBeastScene();
		public var erlkingScene:ErlKingScene = new ErlKingScene();
		// public var dullahanScene:DullahanScene = new DullahanScene(); // [INTERMOD:8chan]

		public function Forest() { }

		public function isDiscovered():Boolean {
			return flags[kFLAGS.TIMES_EXPLORED_FOREST] > 0;
		}
		public function discover():void {
			clearOutput();
			outputText(images.showImage("area-forest"));
			outputText("You walk for quite some time, roaming the hard-packed and pink-tinged earth of the demon-realm.  Rust-red rocks speckle the wasteland, as barren and lifeless as anywhere else you've been.  A cool breeze suddenly brushes against your face, as if gracing you with its presence.  You turn towards it and are confronted by the lush foliage of a very old looking forest.  You smile as the plants look fairly familiar and non-threatening.  Unbidden, you remember your decision to test the properties of this place, and think of your campsite as you walk forward.  Reality seems to shift and blur, making you dizzy, but after a few minutes you're back, and sure you'll be able to return to the forest with similar speed.\n\n<b>You have discovered the Forest!</b>");
			flags[kFLAGS.TIMES_EXPLORED]++;
			flags[kFLAGS.TIMES_EXPLORED_FOREST]++;
			doNext(camp.returnToCampUseOneHour);
		}

		//==============================
		//EVENTS GO HERE!
		//==============================
		private var _forestEncounter:Encounter = null;
		public function get forestEncounter():Encounter { // lateinit because it references getGame()
			const game:CoC     = getGame();
			const fn:FnHelpers = Encounters.fn;
			if (_forestEncounter == null) _forestEncounter =
					Encounters.group(game.commonEncounters.withImpGob, {
						call  : tamaniScene,
						chance: 0.15
					}, game.jojoScene.jojoForest, {
						call  : essrayle.forestEncounter,
						chance: 0.10
					}, corruptedGlade, {
						call  : camp.cabinProgress.forestEncounter,
						chance: 0.5
					}, {
						name  : "deepwoods",
						call  : kGAMECLASS.deepWoods.discover,
						when  : function ():Boolean {
							return (flags[kFLAGS.TIMES_EXPLORED_FOREST] >= 20) && !player.hasStatusEffect(StatusEffects.ExploredDeepwoods);
						},
						chance: Encounters.ALWAYS
					}, {
						name  : "beegirl",
						call  : beeGirlScene.beeEncounter,
						chance: 0.50
					}, {
						name: "tentabeast",
						call: tentacleBeastEncounterFn,
						when: fn.ifLevelMin(2)
					}, {
						name  : "mimic",
						call  : curry(game.mimicScene.mimicTentacleStart, 3),
						when  : fn.ifLevelMin(3),
						chance: 0.50
					}, {
						name  : "succubus",
						call  : game.succubusScene.encounterSuccubus,
						when  : fn.ifLevelMin(3),
						chance: 0.50
					}, {
						name  : "marble",
						call  : marbleVsImp,
						when  : function ():Boolean {
							return flags[kFLAGS.TIMES_EXPLORED_FOREST] > 0 &&
								   !player.hasStatusEffect(StatusEffects.MarbleRapeAttempted)
								   && !player.hasStatusEffect(StatusEffects.NoMoreMarble)
								   && player.hasStatusEffect(StatusEffects.Marble)
								   && flags[kFLAGS.MARBLE_WARNING] == 0;
						},
						chance: 0.10
					}, {
						name: "trip",
						call: tripOnARoot
					}, {
						name  : "chitin",
						call  : findChitin,
						chance: 0.05
					}, {
						name  : "healpill",
						call  : findHPill,
						chance: 0.10
					}, {
						name  : "truffle",
						call  : findTruffle,
						chance: 0.35
					}, {
						name  : "bigjunk",
						call  : game.commonEncounters.bigJunkForestScene,
						chance: game.commonEncounters.bigJunkChance
					}, {
						name: "walk",
						call: forestWalkFn
					});
			return _forestEncounter;
		}

		public function tentacleBeastEncounterFn():void {
			clearOutput();
			//Oh noes, tentacles!
			//Tentacle avoidance chance due to dangerous plants
			if (player.hasKeyItem("Dangerous Plants") >= 0 && player.inte / 2 > rand(50)) {
				trace("TENTACLE'S AVOIDED DUE TO BOOK!");
				outputText(images.showImage("item-dPlants"));
				outputText("Используя знания из книги 'Опасные растения', ты решаешь, что поблизости находится логовище опасного зверя, идти дальше? В противном случае ты можешь вернуться в лагерь.\n\n");
				menu();
				addButton(0, "Дальше", tentacleBeastScene.encounter);
				addButton(4, "Уйти", camp.returnToCampUseOneHour);
			} else {
				tentacleBeastScene.encounter();
			}

		}

		public function tripOnARoot():void {
			outputText(images.showImage("minomob-falling"));
			outputText("Твоя нога попала в выступивший корень, и ты падаешь, при этом сильно поцарапавшись - за исключением этого события, оставшийся час обошелся без приключений.");
			player.takeDamage(10);
			doNext(camp.returnToCampUseOneHour);
		}

		public function findTruffle():void {
			outputText(images.showImage("item-pigTruffle"));
			outputText("В лесу ты натыкаешься на кое-что необычное. При более близком рассмотрении, становится понятно, что это трюфель необычного вида. ");
			inventory.takeItem(consumables.PIGTRUF, camp.returnToCampUseOneHour);
		}
		public function findHPill():void {
			outputText(images.showImage("item-hPill"));
			outputText("В лесу ты находишь валяющуюся на земле пилюлю, со штампом 'H'. ");
			inventory.takeItem(consumables.H_PILL, camp.returnToCampUseOneHour);
		}
		public function findChitin():void {
			outputText(images.showImage("item-bChitin"));
			outputText("В лесу ты находишь крупный кусок хитиновой оболочки, скрытый в кустах папоротника слева от тебя. Кусок почти весь черный с желтоватой кромкой по краю. На котором все еще осталась значительная часть желтого меха, цепляющегося к хитиновому обломку. ");
			if (player.statusEffectv2(StatusEffects.MetRathazul) == 0) outputText("Похоже он крепкий и гибкий - может даже тебе попадется кто-нибудь, кто сможет что-нибудь из него сделать. ");
			inventory.takeItem(useables.B_CHITN, camp.returnToCampUseOneHour);
		}
		public function forestWalkFn():void {
			outputText(images.showImage("area-forest"));
			if (player.cor < 80) {
				outputText("Лес дает тебе хорошо насладиться прогулкой, и это предоставляет время пораскинуть мозгами.");
				dynStats("tou", .5, "int", 1);
			}
			else {
				outputText("Ты слоняешься по лесу, постоянно ");
				if (player.gender == 1) outputText("наяривая свой полуэрегированный " + player.multiCockDescriptLight() + ", пока тем временем перед тобой возникают видения, как ты совокупляешься с самками всех видов, от рыдающих тугих девственниц до полных страсти женщин-суккубов с широко раскрытыми, истекающими дырками.");
				if (player.gender == 2) outputText("играясь лениво своей " + player.vaginaDescript(0) + "ой, пока тем временем перед тобой возникают видения, как в тебя входят чудовищные отростки всех видов, от толстых ароматных минотаврьих молотов до вздымающихся бугристых демонических жезлов удовольствия.");
				if (player.gender == 3) outputText("наяривая поочередно свой " + player.multiCockDescriptLight() + " с " + player.vaginaDescript(0) + "ой, пока тем временем перед тобой возникают видения, как about fucking all kinds of women, from weeping tight virgins to lustful succubi with gaping, drooling fuck-holes, before, or while, getting fucked by various monstrous cocks, from minotaurs' thick, smelly dongs to demons' towering, bumpy pleasure-rods.");
				if (player.gender == 0) outputText("представляя возникающих перед тобой демонов с большущими секс органами, с самыми различными способами их удовлетворения.");
				outputText("");
				dynStats("tou", .5, "lib", .25, "lus", player.lib / 5);
			}
			doNext(camp.returnToCampUseOneHour);
		}


		public function marbleVsImp():void {
			clearOutput();
			outputText("Во время твоего продвижения по лесу, спереди до тебя внезапно доносятся вопль; Cо звуком удара, последовавшим за ним и криком, когда бес пролетая на высокой скорости через листву, находит посадочную полосу у соседнего дерева. Маленький демон медленно скатывается по дереву перед тем, как сползти к его корневищу, и все же... Мгновение спустя знакомая коровка переступает через кустарники, размахивая с сердитым взглядом огромным двуручным молотом.");
			outputText(images.showImage("monster-marble"));
			outputText("\n\nОна подходит к бесу и разок пинает его. Удовлетворившись тем, что существо больше не шевелится, она оборачивается, чтобы встретиться с тобой лицом и улыбнуться. \"<i>Сожалею, что тебе пришлось это видеть, но я предпочитаю сразу браться за этих пидорасов. Если у них появляется шанс позвать своих дружков, то они могут стать довольно большой неприятностью.</i>\" Она обратно исчезает в листве прямо перед тем, как вновь появиться, держа под подмышками две большие груды бревен, с пожарным топором и своим молотом закрепленными на спине. \"<i>Как ты видишь, я собираю дрова для Фермы; что привело тебя в лес, сладость?</i>\" Ты говоришь ей, что лишь исследуешь местность.");
			outputText("\n\nОна делает задумчивый вздох. \"<i>Вообще-то я не исследовала много с тех пор, как пришла на Ферму. Между делами, что дает мне Уитни, остается время на практику с моим молотом, доения, чтобы моя грудь наверняка не стала слишком неподъемна, приготовления еды и сна; у меня не хватает свободного времени сделать еще многое.</i>\" Она вздыхает снова. \"<i>Ну ладно, мне еще нужно отнести все это назад, так что увидимся позже!</i>\"");
			//end event
			doNext(camp.returnToCampUseOneHour);
		}
		public function explore():void
		{
			clearOutput();
			//Increment forest exploration counter.
			flags[kFLAGS.TIMES_EXPLORED_FOREST]++;
			forestEncounter.execEncounter();
		}

	}
}
