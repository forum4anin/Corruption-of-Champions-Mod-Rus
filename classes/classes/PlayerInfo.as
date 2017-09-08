package classes 
{
import classes.GlobalFlags.kGAMECLASS;

import flash.events.Event;
	import fl.controls.ComboBox;;
	import fl.data.DataProvider;
	import classes.*;
	import classes.Scenes.NPCs.IsabellaScene;
	import classes.GlobalFlags.*;
	import classes.display.SpriteDb;
	import classes.internals.*;
	
	/**
	 * The new home of Stats and Perks
	 * @author Kitteh6660
	 */
	public class PlayerInfo extends BaseContent
	{	
		public function PlayerInfo() {}
		
		//------------
		// STATS
		//------------
		public function displayStats():void {
			spriteSelect(null);
			clearOutput();
			displayHeader("Информация");
			// Begin Combat Stats
			var combatStats:String = "";
			
			if (player.hasKeyItem("Bow") >= 0 || player.hasKeyItem("Kelt's Bow") >= 0)
				combatStats += "<b>Мастерство стрельбы:</b> " + Math.round(player.statusEffectv1(StatusEffects.Kelt)) + " / 100\n";
				
			combatStats += "<b>Шанс критического удара:</b> " + Math.round(combat.getCritChance()) + "%\n";	
				
			combatStats += "<b>Шанс уклонения:</b> " + Math.round(player.getEvasionChance()) + "% (Без зависимости от скорости)\n";	
			
			combatStats += "<b>Сопротивление урону:</b> " + (100 - Math.round(player.damagePercent(true))) + "-" + (100 - Math.round(player.damagePercent(true) - player.damageToughnessModifier(true))) + "% (Чем больше, тем лучше.)\n";

			combatStats += "<b>Сопротивление страсти:</b> " + (100 - Math.round(player.lustPercent())) + "% (Чем больше, тем лучше.)\n";
			
			combatStats += "<b>Множитель действия заклятий:</b> " + Math.round(100 * player.spellMod()) + "%\n";
			
			combatStats += "<b>Цена заклятий:</b> " + player.spellCost(100) + "%\n";
			
			if (flags[kFLAGS.RAPHAEL_RAPIER_TRANING] > 0)
				combatStats += "<b>Мастерство парирования:</b> " + flags[kFLAGS.RAPHAEL_RAPIER_TRANING] + " / 4\n";
			
			if (player.teaseLevel < 5)
				combatStats += "<b>Мастерство дразни:</b>  " + player.teaseLevel + " / 5 (Опыт: " + player.teaseXP + " / "+ (10 + (player.teaseLevel + 1) * 5 * (player.teaseLevel + 1))+ ")\n";
			else
				combatStats += "<b>Мастерство дразни</b>  " + player.teaseLevel + " / 5 (Опыт: MAX)\n";	
				
			if (combatStats != "")
				outputText("<b><u>Боевая информация</u></b>\n" + combatStats);
			// End Combat Stats
			
			if (prison.inPrison || flags[kFLAGS.PRISON_CAPTURE_COUNTER] > 0) prison.displayPrisonStats();
			
			// Begin Children Stats
			var childStats:String = "";
			
			if (player.statusEffectv1(StatusEffects.Birthed) > 0)
				childStats += "<b>Родов:</b> " + player.statusEffectv1(StatusEffects.Birthed) + "\n";
				
			if (flags[kFLAGS.AMILY_MET] > 0)
				childStats += "<b>Выводков Эмили:</b> " + (flags[kFLAGS.AMILY_BIRTH_TOTAL] + flags[kFLAGS.PC_TIMES_BIRTHED_AMILYKIDS]) + "\n";

			if (flags[kFLAGS.BEHEMOTH_CHILDREN] > 0)
				childStats += "<b>Потомки Бегемота:</b> " + flags[kFLAGS.BEHEMOTH_CHILDREN] + "\n";

			if (flags[kFLAGS.BENOIT_EGGS] > 0)
				childStats += "<b>Кладки Бенуа:</b> " + flags[kFLAGS.BENOIT_EGGS] + "\n";
			if (flags[kFLAGS.FEMOIT_EGGS_LAID] > 0)
				childStats += "<b>Приплод Бенуа:</b> " + flags[kFLAGS.FEMOIT_EGGS_LAID] + "\n";
				
			if (flags[kFLAGS.COTTON_KID_COUNT] > 0)
				childStats += "<b>Потомки Коттон:</b> " + flags[kFLAGS.COTTON_KID_COUNT] + "\n";
			
			if (flags[kFLAGS.EDRYN_NUMBER_OF_KIDS] > 0)
				childStats += "<b>Потомки Эдрин:</b> " + flags[kFLAGS.EDRYN_NUMBER_OF_KIDS] + "\n";
				
			if (flags[kFLAGS.EMBER_CHILDREN_MALES] > 0)
				childStats += "<b>Отпрыски Эмбер" + getGame().emberScene.emberMF("а", "") + " (М):</b> " + flags[kFLAGS.EMBER_CHILDREN_MALES] + "\n";
			if (flags[kFLAGS.EMBER_CHILDREN_FEMALES] > 0)
				childStats += "<b>Отпрыски Эмбер" + getGame().emberScene.emberMF("а", "") + " (Ж):</b> " + flags[kFLAGS.EMBER_CHILDREN_FEMALES] + "\n";
			if (flags[kFLAGS.EMBER_CHILDREN_HERMS] > 0)
				childStats += "<b>Отпрыски Эмбер" + getGame().emberScene.emberMF("а", "") + " (Г):</b> " + flags[kFLAGS.EMBER_CHILDREN_HERMS] + "\n";
			if (getGame().emberScene.emberChildren() > 0)
				childStats += "<b>Все потомки Эмбер" + getGame().emberScene.emberMF("а", "") + ":</b> " + (getGame().emberScene.emberChildren()) + "\n";
			
			if (flags[kFLAGS.EMBER_EGGS] > 0)
				childStats += "<b>Приплод Эмбер" + getGame().emberScene.emberMF("а", "") + ":</b> " + flags[kFLAGS.EMBER_EGGS] + "\n";
				
			if (getGame().isabellaScene.totalIsabellaChildren() > 0) {
				if (getGame().isabellaScene.getIsabellaChildType(IsabellaScene.OFFSPRING_HUMAN_BOYS) > 0)
					childStats += "<b>Потомки Изабеллы (Человек, М):</b> " + getGame().isabellaScene.getIsabellaChildType(IsabellaScene.OFFSPRING_HUMAN_BOYS) + "\n";
				if (getGame().isabellaScene.getIsabellaChildType(IsabellaScene.OFFSPRING_HUMAN_GIRLS) > 0)
					childStats += "<b>Потомки Изабеллы (Человек, Ж):</b> " + getGame().isabellaScene.getIsabellaChildType(IsabellaScene.OFFSPRING_HUMAN_GIRLS) + "\n";
				if (getGame().isabellaScene.getIsabellaChildType(IsabellaScene.OFFSPRING_HUMAN_HERMS) > 0)
					childStats += "<b>Потомки Изабеллы (Человек, Г):</b> " + getGame().isabellaScene.getIsabellaChildType(IsabellaScene.OFFSPRING_HUMAN_HERMS) + "\n";
				if (getGame().isabellaScene.getIsabellaChildType(IsabellaScene.OFFSPRING_COWGIRLS) > 0)
					childStats += "<b>Потомки Изабеллы (Корова, Ж)</b> " + getGame().isabellaScene.getIsabellaChildType(IsabellaScene.OFFSPRING_COWGIRLS) + "\n";
				if (getGame().isabellaScene.getIsabellaChildType(IsabellaScene.OFFSPRING_COWFUTAS) > 0)
					childStats += "<b>Потомки Изабеллы (Корова, Г)</b> " + getGame().isabellaScene.getIsabellaChildType(IsabellaScene.OFFSPRING_COWFUTAS) + "\n";
				childStats += "<b>Все потомки Изабеллы:</b> " + getGame().isabellaScene.totalIsabellaChildren() + "\n"
			}
				
				
			if (flags[kFLAGS.IZMA_CHILDREN_SHARKGIRLS] > 0)
				childStats += "<b>Потомки Измы (Акула):</b> " + flags[kFLAGS.IZMA_CHILDREN_SHARKGIRLS] + "\n";
			if (flags[kFLAGS.IZMA_CHILDREN_TIGERSHARKS] > 0)
				childStats += "<b>Потомки Измы (Тигровая акула):</b> " + flags[kFLAGS.IZMA_CHILDREN_TIGERSHARKS] + "\n";
			if (flags[kFLAGS.IZMA_CHILDREN_SHARKGIRLS] > 0 && flags[kFLAGS.IZMA_CHILDREN_TIGERSHARKS] > 0)
				childStats += "<b>Все потомки Измы:</b> " + (flags[kFLAGS.IZMA_CHILDREN_SHARKGIRLS] + flags[kFLAGS.IZMA_CHILDREN_TIGERSHARKS]) + "\n";
				
			if (getGame().joyScene.getTotalLitters() > 0)
				childStats += "<b>Выводков " + (flags[kFLAGS.JOJO_BIMBO_STATE] >= 3 ? "Джоя" : "Джоджо") + ":</b> " + getGame().joyScene.getTotalLitters() + "\n";
				
			if (flags[kFLAGS.KELLY_KIDS_MALE] > 0)
				childStats += "<b>Потомки Келли (М):</b> " + flags[kFLAGS.KELLY_KIDS_MALE] + "\n";
			if (flags[kFLAGS.KELLY_KIDS] - flags[kFLAGS.KELLY_KIDS_MALE] > 0)
				childStats += "<b>Потомки Келли (Ж):</b> " + (flags[kFLAGS.KELLY_KIDS] - flags[kFLAGS.KELLY_KIDS_MALE]) + "\n";
			if (flags[kFLAGS.KELLY_KIDS] > 0)
				childStats += "<b>Все потомки Келли:</b> " + flags[kFLAGS.KELLY_KIDS] + "\n";
			//if (getGame().kihaFollower.pregnancy.isPregnant) This was originally a debug.
			//	childStats += "<b>Kiha's Pregnancy:</b> " + getGame().kihaFollower.pregnancy.incubation + "\n";
			if (flags[kFLAGS.KIHA_CHILDREN_BOYS] > 0)
				childStats += "<b>Отпрыски Кихи (М):</b> " + flags[kFLAGS.KIHA_CHILDREN_BOYS] + "\n";
			if (flags[kFLAGS.KIHA_CHILDREN_GIRLS] > 0)
				childStats += "<b>Отпрыски Кихи (Ж):</b> " + flags[kFLAGS.KIHA_CHILDREN_GIRLS] + "\n";
			if (flags[kFLAGS.KIHA_CHILDREN_HERMS] > 0)
				childStats += "<b>Отпрыски Кихи (Г):</b> " + flags[kFLAGS.KIHA_CHILDREN_HERMS] + "\n";
			if (getGame().kihaFollower.totalKihaChildren() > 0)
				childStats += "<b>Все потомки Кихи:</b> " + getGame().kihaFollower.totalKihaChildren() + "\n";
				
			if (getGame().mountain.salon.lynnetteApproval() != 0)
				childStats += "<b>Потомки Линнетт:</b> " + flags[kFLAGS.LYNNETTE_BABY_COUNT] + "\n";
				
			if (flags[kFLAGS.MARBLE_KIDS] > 0)
				childStats += "<b>Потомки Марбл:</b> " + flags[kFLAGS.MARBLE_KIDS] + "\n";
				
			if (flags[kFLAGS.MINERVA_CHILDREN] > 0)
				childStats += "<b>Потомки Минервы:</b> " + flags[kFLAGS.MINERVA_CHILDREN] + "\n";
				
			if (flags[kFLAGS.ANT_KIDS] > 0)
				childStats += "<b>Муравьев от Филлы:</b> " + flags[kFLAGS.ANT_KIDS] + "\n";
			if (flags[kFLAGS.PHYLLA_DRIDER_BABIES_COUNT] > 0)
				childStats += "<b>Драуков от Филлы:</b> " + flags[kFLAGS.PHYLLA_DRIDER_BABIES_COUNT] + "\n";
			if (flags[kFLAGS.ANT_KIDS] > 0 && flags[kFLAGS.PHYLLA_DRIDER_BABIES_COUNT] > 0)
				childStats += "<b>Все потомки Филлы:</b> " + (flags[kFLAGS.ANT_KIDS] + flags[kFLAGS.PHYLLA_DRIDER_BABIES_COUNT]) + "\n";
				
			if (flags[kFLAGS.SHEILA_JOEYS] > 0)
				childStats += "<b>Потомки Шейлы (Кенгурята):</b> " + flags[kFLAGS.SHEILA_JOEYS] + "\n";
			if (flags[kFLAGS.SHEILA_IMPS] > 0)
				childStats += "<b>Потомки Шейлы (Бесы):</b> " + flags[kFLAGS.SHEILA_IMPS] + "\n";
			if (flags[kFLAGS.SHEILA_JOEYS] > 0 && flags[kFLAGS.SHEILA_IMPS] > 0)
				childStats += "<b>Все потомки Шейлы:</b> " + (flags[kFLAGS.SHEILA_JOEYS] + flags[kFLAGS.SHEILA_IMPS]) + "\n";
				
			if (flags[kFLAGS.SOPHIE_ADULT_KID_COUNT] > 0 || flags[kFLAGS.SOPHIE_DAUGHTER_MATURITY_COUNTER] > 0) 
			{
				childStats += "<b>Потомки Софи:</b> ";
				var sophie:int = 0;
				if (flags[kFLAGS.SOPHIE_DAUGHTER_MATURITY_COUNTER] > 0) sophie++;
				sophie += flags[kFLAGS.SOPHIE_ADULT_KID_COUNT];
				if (flags[kFLAGS.SOPHIE_CAMP_EGG_COUNTDOWN] > 0) sophie++;
				childStats += sophie + "\n";
			}
			
			if (flags[kFLAGS.SOPHIE_EGGS_LAID] > 0)
				childStats += "<b>Оплодотворено яиц Софи:</b> " + (flags[kFLAGS.SOPHIE_EGGS_LAID] + sophie) + "\n";
				
			if (flags[kFLAGS.TAMANI_NUMBER_OF_DAUGHTERS] > 0)
				childStats += "<b>Потомки Тамани:</b> " + flags[kFLAGS.TAMANI_NUMBER_OF_DAUGHTERS] + " (после всех видов естественного отбора)\n";
				
			if (getGame().urtaPregs.urtaKids() > 0)
				childStats += "<b>Потомки Урты:</b> " + getGame().urtaPregs.urtaKids() + "\n";
				
			//Mino sons
			if (flags[kFLAGS.ADULT_MINOTAUR_OFFSPRINGS] > 0)
				childStats += "<b>Взрослые потомки минотавров:</b> " + flags[kFLAGS.ADULT_MINOTAUR_OFFSPRINGS] + "\n";
			
			if (childStats != "")
				outputText("\n<b><u>Потомки</u></b>\n" + childStats);
			// End Children Stats

			// Begin Body Stats
			var bodyStats:String = "";

			if (flags[kFLAGS.HUNGER_ENABLED] > 0 || flags[kFLAGS.IN_PRISON] > 0)
			{
				bodyStats += "<b>Сытость:</b> " + Math.floor(player.hunger) + " / 100 (";
				if (player.hunger <= 0) bodyStats += "<font color=\"#ff0000\">Умираешь</font>";
				if (player.hunger > 0 && player.hunger < 10) bodyStats += "<font color=\"#C00000\">Умираешь от голода</font>";
				if (player.hunger >= 10 && player.hunger < 25) bodyStats += "<font color=\"#800000\">Сильно голодаешь</font>";
				if (player.hunger >= 25 && player.hunger100 < 50) bodyStats += "Голодаешь";
				if (player.hunger100 >= 50 && player.hunger100 < 75) bodyStats += "Не голодаешь";
				if (player.hunger100 >= 75 && player.hunger100 < 90) bodyStats += "<font color=\"#008000\">Утоляешь голод</font>";
				if (player.hunger100 >= 90 && player.hunger100 < 100) bodyStats += "<font color=\"#00C000\">Наедаешься</font>";
				if (player.hunger100 >= 100) bodyStats += "<font color=\"#00C000\">Объедаешься</font>";
				bodyStats += ")\n";
			}

			bodyStats += "<b>Вместимость анала:</b> " + Math.round(player.analCapacity()) + "\n";
			bodyStats += "<b>Растянутость анала:</b> " + Math.round(player.ass.analLooseness) + "\n";
			
			bodyStats += "<b>Показатель плодоносия (Базовой):</b> " + Math.round(player.fertility) + "\n";
			bodyStats += "<b>Показатель плодоносия (С бонусами):</b> " + Math.round(player.totalFertility()) + "\n";
			
			if (player.cumQ() > 0) {
				bodyStats += "<b>Показатель зрелости:</b> " + Math.round(player.virilityQ() * 100) + "\n";
				if (flags[kFLAGS.HUNGER_ENABLED] >= 1) bodyStats += "<b>Выработка спермы:</b> " + addComma(Math.round(player.cumQ())) + " / " + addComma(Math.round(player.cumCapacity())) + "мл (" + Math.round((player.cumQ() / player.cumCapacity()) * 100) + "%) \n";
				else bodyStats += "<b>Выработка спермы:</b> " + addComma(Math.round(player.cumQ())) + "мл\n";
			}
			if (player.lactationQ() > 0)
				bodyStats += "<b>Выработка молока:</b> " + addComma(Math.round(player.lactationQ())) + "мл\n";
			
			if (player.hasStatusEffect(StatusEffects.Feeder)) {
				bodyStats += "<b>Часов с последнего кормления своей грудью:</b>  " + player.statusEffectv2(StatusEffects.Feeder);
				if (player.statusEffectv2(StatusEffects.Feeder) >= 72)
					bodyStats += " (Слишком долго! Чувствительность возросла!)";
				
				bodyStats += "\n";
			}
			
			bodyStats += "<b>Множитель длительности беременности:</b> ";
			var preg:Number = 1;
			if (player.findPerk(PerkLib.Diapause) >= 0)
				bodyStats += "? (Изменчиво в связи с задержкой)\n";
			else {
				if (player.findPerk(PerkLib.MaraesGiftFertility) >= 0) preg++;
				if (player.findPerk(PerkLib.BroodMother) >= 0) preg++;
				if (player.findPerk(PerkLib.FerasBoonBreedingBitch) >= 0) preg++;
				if (player.findPerk(PerkLib.MagicalFertility) >= 0) preg++;
				if (player.findPerk(PerkLib.FerasBoonWideOpen) >= 0 || player.findPerk(PerkLib.FerasBoonMilkingTwat) >= 0) preg++;
				bodyStats += preg + "\n";
			}
			
			if (player.cocks.length > 0) {
				bodyStats += "<b>Кол-во мужских половых органов:</b> " + player.cocks.length + "\n";

				var totalCockLength:Number = 0;
				var totalCockGirth:Number = 0;
				
				for (var i:Number = 0; i < player.cocks.length; i++) {
						totalCockLength += player.cocks[i].cockLength;
						totalCockGirth += player.cocks[i].cockThickness
				}
						
				bodyStats += "<b>Длина мужских половых органов:</b> " + Math.round(totalCockLength) + " дюймов\n";
				bodyStats += "<b>Диаметр мужских половых органов:</b> " + Math.round(totalCockGirth) + " дюймов\n";
				
			}
			
			if (player.vaginas.length > 0)
				bodyStats += "<b>Вместимость влагалища:</b> " + Math.round(player.vaginalCapacity()) + "\n" + "<b>Растянутость влагалища:</b> " + Math.round(player.looseness()) + "\n";

			if (player.findPerk(PerkLib.SpiderOvipositor) >= 0 || player.findPerk(PerkLib.BeeOvipositor) >= 0)
				bodyStats += "<b>Общее число яиц в яйцекладе: " + player.eggs() + "\nОбщее число оплодотворенных яиц в яйцекладе: " + player.fertilizedEggs() + "</b>\n";
				
			if (player.hasStatusEffect(StatusEffects.SlimeCraving)) {
				if (player.statusEffectv1(StatusEffects.SlimeCraving) >= 18)
					bodyStats += "<b>Жажда слизи:</b> Активна! В течение жажды ты утрачиваешь силу и скорость. Тебе следует найти жидкость.\n";
				else {
					if (player.findPerk(PerkLib.SlimeCore) >= 0)
						bodyStats += "<b>Слизи накоплено:</b> " + ((17 - player.statusEffectv1(StatusEffects.SlimeCraving)) * 2) + " часов до того как ты начнешь утрачивать силу.\n";
					else
						bodyStats += "<b>Слизи накоплено:</b> " + (17 - player.statusEffectv1(StatusEffects.SlimeCraving)) + " часов до того как ты начнешь утрачивать силу.\n";
				}
			}
			
			if (bodyStats != "")
				outputText("\n<b><u>Тело</u></b>\n" + bodyStats);
			// End Body Stats
			
			
			// Begin Racial Scores display -Foxwells
			var raceScores:String = "";
			
			if (player.humanScore() > 0) {
				raceScores += "<b>Показатель человека:</b> " + player.humanScore() + "\n";
			}
			if (player.mutantScore() > 0) {
				raceScores += "<b>Показатель мутанта:</b> " + player.mutantScore() + "\n";
			}
			if (player.demonScore() > 0) {
				raceScores += "<b>Показатель демона:</b> " + player.demonScore() + "\n";
			}
			if (player.goblinScore() > 0) {
				raceScores += "<b>Показатель гоблина:</b> " + player.goblinScore() + "\n";
			}
			if (player.gooScore() > 0) {
				raceScores += "<b>Показатель слизня:</b> " + player.gooScore() + "\n";
			}
			if (player.cowScore() > 0) {
				raceScores += "<b>Показатель коровы:</b> " + player.cowScore() + "\n";
			}
			if (player.minoScore() > 0) {
				raceScores += "<b>Показатель минотавра:</b> " + player.minoScore() + "\n";
			}
			if (player.catScore() > 0) {
				raceScores += "<b>Показатель кошки:</b> " + player.catScore() + "\n";
			}
			if (player.dragonneScore() > 0) {
				raceScores += "<b>Показатель дрогона:</b> " + player.dragonneScore() + "\n";
			}
			if (player.manticoreScore() > 0) {
				raceScores += "<b>Показатель мантикоры:</b> " + player.manticoreScore() + "\n";
			}
			if (player.lizardScore() > 0) {
				raceScores += "<b>Показатель ящера:</b> " + player.lizardScore() + "\n";
			}
			if (player.salamanderScore() > 0) {
				raceScores += "<b>Показатель саламандры:</b> " + player.salamanderScore() + "\n";
			}
			if (player.dragonScore() > 0) {
				raceScores += "<b>Показатель дракона:</b> " + player.dragonScore() + "\n";
			}
			if (player.nagaScore() > 0) {
				raceScores += "<b>Показатель нажки:</b> " + player.nagaScore() + "\n";
			}
			if (player.sandTrapScore() > 0) {
				raceScores += "<b>Показатель песчаника:</b> " + player.sandTrapScore() + "\n";
			}
			if (player.harpyScore() > 0) {
				raceScores += "<b>Показатель птицы:</b> " + player.harpyScore() + "\n";
			}
			if (player.sharkScore() > 0) {
				raceScores += "<b>Показатель акулы:</b> " + player.sharkScore() + "\n";
			}
			if (player.sirenScore() > 0) {
				raceScores += "<b>Показатель сирены:</b> " + player.sirenScore() + "\n";
			}
			if (player.dogScore() > 0) {
				raceScores += "<b>Показатель пса:</b> " + player.dogScore() + "\n";
			}
			if (player.wolfScore() > 0) {
				raceScores += "<b>Показатель волка:</b> " + player.wolfScore() + "\n";
			}
			if (player.foxScore() > 0) {
				raceScores += "<b>Показатель лисы:</b> " + player.foxScore() + "\n";
			}
			if (player.kitsuneScore() > 0) {
				raceScores += "<b>Показатель кицунэ:</b> " + player.kitsuneScore() + "\n";
			}
			if (player.echidnaScore() > 0) {
				raceScores += "<b>Показатель ехидны:</b> " + player.echidnaScore() + "\n";
			}
			if (player.mouseScore() > 0) {
				raceScores += "<b>Показатель мыши:</b> " + player.mouseScore() + "\n";
			}
			if (player.ferretScore() > 0) {
				raceScores += "<b>Показатель хорька:</b> " + player.ferretScore() + "\n";
			}
			if (player.raccoonScore() > 0) {
				raceScores += "<b>Показатель енота:</b> " + player.raccoonScore() + "\n";
			}
			if (player.bunnyScore() > 0) {
				raceScores += "<b>Показатель кролика:</b> " + player.bunnyScore() + "\n";
			}
			if (player.kangaScore() > 0) {
				raceScores += "<b>Показатель кенгуру:</b> " + player.kangaScore() + "\n";
			}
			if (player.horseScore() > 0) {
				raceScores += "<b>Показатель коня:</b> " + player.horseScore() + "\n";
			}
			if (player.deerScore() > 0) {
				raceScores += "<b>Показатель оленя:</b> " + player.deerScore() + "\n";
			}
			if (player.satyrScore() > 0) {
				raceScores += "<b>Показатель сатира:</b> " + player.satyrScore() + "\n";
			}
			if (player.rhinoScore() > 0) {
				raceScores += "<b>Показатель носорога:</b> " + player.rhinoScore() + "\n";
			}
			if (player.spiderScore() > 0) {
				raceScores += "<b>Показатель паука:</b> " + player.spiderScore() + "\n";
			}
			if (player.pigScore() > 0) {
				raceScores += "<b>Показатель хряка:</b> " + player.pigScore() + "\n";
			}
			if (player.beeScore() > 0) {
				raceScores += "<b>Показатель пчелы:</b> " + player.beeScore() + "\n";
			}
			if (player.cockatriceScore() > 0) {
				raceScores += "<b>Показатель кокатрикса:</b> " + player.cockatriceScore() + "\n";
			}
			
			if (raceScores != "")
				outputText("\n<b><u>Показатели расы</u></b>\n" + raceScores);
			// End Racial Scores display -Foxwells

			// Begin Misc Stats
			var miscStats:String = "";

			if (camp.getCampPopulation() > 0)
				miscStats += "<b>Население лагеря::</b> " + camp.getCampPopulation() + "\n";
			
			if (flags[kFLAGS.CORRUPTED_GLADES_DESTROYED] > 0) {
				if (flags[kFLAGS.CORRUPTED_GLADES_DESTROYED] < 100)
					miscStats += "<b>Информация по полянам разврата:</b> " + (100 - flags[kFLAGS.CORRUPTED_GLADES_DESTROYED]) + "% осталось\n";
				else 
					miscStats += "<b>Информация по полянам разврата:</b> Исчезли\n";
			}
				
			if (flags[kFLAGS.EGGS_BOUGHT] > 0)
				miscStats += "<b>Обменено яиц:</b> " + flags[kFLAGS.EGGS_BOUGHT] + "\n";
			
			if (flags[kFLAGS.TIMES_AUTOFELLATIO_DUE_TO_CAT_FLEXABILITY] > 0)
				miscStats += "<b>Сколько раз довелось развлекаться с кошачьей гибкостью:</b> " + flags[kFLAGS.TIMES_AUTOFELLATIO_DUE_TO_CAT_FLEXABILITY] + "\n";
			
			if (flags[kFLAGS.FAP_ARENA_SESSIONS] > 0)
				miscStats += "<b>Сколько раз довелось помастурбировать на арене:</b> " + flags[kFLAGS.FAP_ARENA_SESSIONS] + "\n<b>Побед на арене:</b> " + flags[kFLAGS.FAP_ARENA_VICTORIES] + "\n";
			
			if (flags[kFLAGS.SPELLS_CAST] > 0)
				miscStats += "<b>Заклятий произнесено:</b> " + flags[kFLAGS.SPELLS_CAST] + "\n";
			
			if (flags[kFLAGS.TIMES_BAD_ENDED] > 0)
				miscStats += "<b>Сколько раз довелось получить плохую концовку:</b> " + flags[kFLAGS.TIMES_BAD_ENDED] + "\n";
			
			if (flags[kFLAGS.TIMES_ORGASMED] > 0)
				miscStats += "<b>Сколько раз довелось получить оргазм:</b> " + flags[kFLAGS.TIMES_ORGASMED] + "\n";
				
			if (getGame().bimboProgress.ableToProgress()) {
				if (flags[kFLAGS.TIMES_ORGASM_DICK] > 0) 
					miscStats += "<i>Упругость члена::</i> " + flags[kFLAGS.TIMES_ORGASM_DICK] + "\n";
				if (flags[kFLAGS.TIMES_ORGASM_ANAL] > 0) 
					miscStats += "<i>Упругость задницы:</i> " + flags[kFLAGS.TIMES_ORGASM_ANAL] + "\n";
				if (flags[kFLAGS.TIMES_ORGASM_VAGINAL] > 0) 
					miscStats += "<i>Упругость влагалища:</i> " + flags[kFLAGS.TIMES_ORGASM_VAGINAL] + "\n";
				if (flags[kFLAGS.TIMES_ORGASM_TITS] > 0) 
					miscStats += "<i>Упругость титек:</i> " + flags[kFLAGS.TIMES_ORGASM_TITS] + "\n";
				if (flags[kFLAGS.TIMES_ORGASM_LIPS] > 0) 
					miscStats += "<i>Упругость губ:</i> " + flags[kFLAGS.TIMES_ORGASM_LIPS] + "\n";
				miscStats += "<i>Показатель Барби:</i> " + Math.round(player.bimboScore() * 10) + "\n";
			}

			
			if (miscStats != "")
				outputText("\n<b><u>Разное</u></b>\n" + miscStats);
			// End Misc Stats
			
			// Begin Addition Stats
			var addictStats:String = "";
			//Marble Milk Addition
			if (player.statusEffectv3(StatusEffects.Marble) > 0) {
				addictStats += "<b>Молоко Марбл:</b> ";
				if (player.findPerk(PerkLib.MarbleResistant) < 0 && player.findPerk(PerkLib.MarblesMilk) < 0)
					addictStats += Math.round(player.statusEffectv2(StatusEffects.Marble)) + "%\n";
				else if (player.findPerk(PerkLib.MarbleResistant) >= 0)
					addictStats += "0%\n";
				else
					addictStats += "100%\n";
			}
			
			// Corrupted Minerva's Cum Addiction
			if (flags[kFLAGS.MINERVA_CORRUPTION_PROGRESS] >= 10 && flags[kFLAGS.MINERVA_CORRUPTED_CUM_ADDICTION] > 0) {
				addictStats += "<b>Семя Минервы:</b> " + (flags[kFLAGS.MINERVA_CORRUPTED_CUM_ADDICTION] * 20) + "%";
			}
			
			// Mino Cum Addiction
			if (flags[kFLAGS.MINOTAUR_CUM_INTAKE_COUNT] > 0 || flags[kFLAGS.MINOTAUR_CUM_ADDICTION_TRACKER] > 0 || player.findPerk(PerkLib.MinotaurCumAddict) >= 0 || player.findPerk(PerkLib.MinotaurCumResistance) >= 0) {
				if (player.findPerk(PerkLib.MinotaurCumAddict) < 0)
					addictStats += "<b>Семя Минотавра:</b> " + Math.round(flags[kFLAGS.MINOTAUR_CUM_ADDICTION_TRACKER] * 10)/10 + "%\n";
				else if (player.findPerk(PerkLib.MinotaurCumResistance) >= 0)
					addictStats += "<b>Семя Минотавра:</b> 0% (Иммунитет)\n";
				else
					addictStats += "<b>Семя Минотавра:</b> 100+%\n";
			}
			
			if (addictStats != "")
				outputText("\n<b><u>Зависимости</u></b>\n" + addictStats);
			// End Addition Stats
			
			// Begin Interpersonal Stats
			var interpersonStats:String = "";
			
			if (getGame().dungeons.palace.anzuScene.anzuRelationshipLevel() > 0) {
				interpersonStats += "<b>Привязанность Анзу:</b> " + flags[kFLAGS.ANZU_AFFECTION] + "%\n";
				interpersonStats += "<b>Уровень отношений с Анзу:</b> " + (flags[kFLAGS.ANZU_RELATIONSHIP_LEVEL] == 1 ? "Знакомый" : flags[kFLAGS.ANZU_RELATIONSHIP_LEVEL] == 2 ? "Друг" : flags[kFLAGS.ANZU_RELATIONSHIP_LEVEL] == 3 ? "Близкий друг" : flags[kFLAGS.ANZU_RELATIONSHIP_LEVEL] == 4 ? "Любовник" : "Неопределившийся") + "\n";
			}
			
			if (flags[kFLAGS.ARIAN_PARK] > 0)
				interpersonStats += "<b>Самочувствие Ариан" + getGame().arianScene.arianMF("а", "ны") + ":</b> " + Math.round(getGame().arianScene.arianHealth()) + "\n";
				
			if (flags[kFLAGS.ARIAN_VIRGIN] > 0)
				interpersonStats += "<b>Счетчик занятий сексом с Ариан" + getGame().arianScene.arianMF("ом", "ной") + ":</b> " + Math.round(flags[kFLAGS.ARIAN_VIRGIN]) + "\n";
			
			if (getGame().bazaar.benoit.benoitAffection() > 0)
				interpersonStats += "<b>Привязанность" + getGame().bazaar.benoit.benoitMF("Бенуа", "Бенуаты") + ":</b> " + Math.round(getGame().bazaar.benoit.benoitAffection()) + "%\n";
			
			if (flags[kFLAGS.BROOKE_MET] > 0)
				interpersonStats += "<b>Привязанность Брук:</b> " + Math.round(getGame().telAdre.brooke.brookeAffection()) + "\n";
				
			if (flags[kFLAGS.CERAPH_DICKS_OWNED] + flags[kFLAGS.CERAPH_PUSSIES_OWNED] + flags[kFLAGS.CERAPH_TITS_OWNED] > 0)
				interpersonStats += "<b>Частей тела отобрано Сераф:</b> " + (flags[kFLAGS.CERAPH_DICKS_OWNED] + flags[kFLAGS.CERAPH_PUSSIES_OWNED] + flags[kFLAGS.CERAPH_TITS_OWNED]) + "\n";
				
			if (getGame().emberScene.emberAffection() > 0)
				interpersonStats += "<b>Привязанность Эмбер" + getGame().emberScene.emberMF("а", "") + ":</b> " + Math.round(getGame().emberScene.emberAffection()) + "%\n";
			if (getGame().emberScene.emberSparIntensity() > 0)
				interpersonStats += "<b>Интенсивность спаррингов с Эмбер" + getGame().emberScene.emberMF("ом", "") + ":</b> " + getGame().emberScene.emberSparIntensity() + "\n";
				
			if (getGame().helFollower.helAffection() > 0)
				interpersonStats += "<b>Привязанность Хелии:</b> " + Math.round(getGame().helFollower.helAffection()) + "%\n";
			if (getGame().helFollower.helAffection() >= 100)
				interpersonStats += "<b>Дополнительные баллы Хелии:</b> " + Math.round(flags[kFLAGS.HEL_BONUS_POINTS]) + "\n";
			if (getGame().helFollower.followerHel())
				interpersonStats += "<b>Интенсивность спаррингов с Хелией:</b> " + getGame().helScene.heliaSparIntensity() + "\n";
			
			if (flags[kFLAGS.ISABELLA_AFFECTION] > 0) {
				interpersonStats += "<b>Привязанность Изабеллы:</b> ";
				
				if (!getGame().isabellaFollowerScene.isabellaFollower())
					interpersonStats += Math.round(flags[kFLAGS.ISABELLA_AFFECTION]) + "%\n", false;
				else
					interpersonStats += "100%\n";
			}
			
			if (flags[kFLAGS.JOJO_BIMBO_STATE] >= 3) {
				interpersonStats += "<b>Интеллект Джоя:</b> " + flags[kFLAGS.JOY_INTELLIGENCE];
				if (flags[kFLAGS.JOY_INTELLIGENCE] >= 50) interpersonStats += " (MAX)"
				interpersonStats += "\n";
			}
			
			if (flags[kFLAGS.KATHERINE_UNLOCKED] >= 4) {
				interpersonStats += "<b>Покорность Кэтрин:</b> " + getGame().telAdre.katherine.submissiveness() + "\n";
			}

			if (player.hasStatusEffect(StatusEffects.Kelt) && flags[kFLAGS.KELT_BREAK_LEVEL] == 0 && flags[kFLAGS.KELT_KILLED] == 0) {
				if (player.statusEffectv2(StatusEffects.Kelt) >= 130)
					interpersonStats += "<b>Покорность Кельту:</b> " + 100 + "%\n";
				else
					interpersonStats += "<b>Покорность Кельту:</b> " + Math.round(player.statusEffectv2(StatusEffects.Kelt) / 130 * 100) + "%\n";
					
			}
			
			if (flags[kFLAGS.ANEMONE_KID] > 0)
				interpersonStats += "<b>Доверие Киддо:</b> " + getGame().anemoneScene.kidAXP() + "%\n";

			if (flags[kFLAGS.KIHA_AFFECTION_LEVEL] >= 2 || getGame().kihaFollower.followerKiha()) {
				if (getGame().kihaFollower.followerKiha())
					interpersonStats += "<b>Привязанность Кихи:</b> " + 100 + "%\n";
				else
					interpersonStats += "<b>Привязанность Кихи:</b> " + Math.round(flags[kFLAGS.KIHA_AFFECTION]) + "%\n";
			}
			//Lottie stuff
			if (flags[kFLAGS.LOTTIE_ENCOUNTER_COUNTER] > 0)
				interpersonStats += "<b>Поддержка Лотти:</b> " + getGame().telAdre.lottie.lottieMorale() + " (Чем больше, тем лучше)\n" + "<b>Стан Лотти:</b> " + getGame().telAdre.lottie.lottieTone() + " (Чем больше, тем лучше)\n";
			
			if (getGame().mountain.salon.lynnetteApproval() != 0)
				interpersonStats += "<b>Одобрение Линнетт:</b> " + getGame().mountain.salon.lynnetteApproval() + "\n";
			
			if (player.statusEffectv1(StatusEffects.Marble) > 0)
				interpersonStats += "<b>Привязанность Марбл:</b>" + player.statusEffectv1(StatusEffects.Marble) + "%\n";
				
			if (flags[kFLAGS.OWCAS_ATTITUDE] > 0)
				interpersonStats += "<b>Отношение Овцы:</b> " + flags[kFLAGS.OWCAS_ATTITUDE] + "\n";

			if (getGame().telAdre.pablo.pabloAffection() > 0)
				interpersonStats += "<b>Привязанность Пабло:</b> " + flags[kFLAGS.PABLO_AFFECTION] + "%\n";
				
			if (getGame().telAdre.rubi.rubiAffection() > 0)
				interpersonStats += "<b>Привязанность Руби:</b> " + Math.round(getGame().telAdre.rubi.rubiAffection()) + "%\n" + "<b>Вместимость сопла Руби:</b> " + Math.round(getGame().telAdre.rubi.rubiCapacity()) + "%\n";

			if (flags[kFLAGS.SHEILA_XP] != 0) {
				interpersonStats += "<b>Разврат Шейлы:</b> " + getGame().sheilaScene.sheilaCorruption();
				if (getGame().sheilaScene.sheilaCorruption() > 100)
					interpersonStats += " (Да, он может превышать 100)";
				interpersonStats += "\n";
			}
			
			if (getGame().valeria.valeriaFluidsEnabled()) {
				interpersonStats += "<b>Жидкость Валерии:</b> " + flags[kFLAGS.VALERIA_FLUIDS] + "%\n"
			}
			
			if (flags[kFLAGS.URTA_COMFORTABLE_WITH_OWN_BODY] != 0) {
				if (getGame().urta.urtaLove()) {
					if (flags[kFLAGS.URTA_QUEST_STATUS] == -1) interpersonStats += "<b>Состояние Урты:</b> <font color=\"#800000\">Пропала</font>\n";
					if (flags[kFLAGS.URTA_QUEST_STATUS] == 0) interpersonStats += "<b>Состояние Урты:</b> Любовница\n";
					if (flags[kFLAGS.URTA_QUEST_STATUS] == 1) interpersonStats += "<b>Состояние Урты:</b> <font color=\"#008000\">Любовница+</font>\n";
				}
				else if (flags[kFLAGS.URTA_COMFORTABLE_WITH_OWN_BODY] == -1)
					interpersonStats += "<b>Состояние Урты:</b> Стыдится\n";
				else if (flags[kFLAGS.URTA_PC_AFFECTION_COUNTER] < 30)
					interpersonStats += "<b>Привязанность Урты:</b> " + Math.round(flags[kFLAGS.URTA_PC_AFFECTION_COUNTER] * 3.3333) + "%\n";
				else
					interpersonStats += "<b>Состояние Урты:</b> Готова признаться в любви\n";
			}
			
			if (interpersonStats != "")
				outputText("\n<b><u>Отношения</u></b>\n" + interpersonStats);
			// End Interpersonal Stats
			
			// Begin Ongoing Stat Effects
			var statEffects:String = "";
			
			if (player.inHeat)
				statEffects += "Течка - " + Math.round(player.statusEffectv3(StatusEffects.Heat)) + " час(ов) осталось\n";
				
			if (player.inRut)
				statEffects += "В охоте - " + Math.round(player.statusEffectv3(StatusEffects.Rut)) + " час(ов) осталось\n";
				
			if (player.statusEffectv1(StatusEffects.Luststick) > 0)
				statEffects += "Помада страсти - " + Math.round(player.statusEffectv1(StatusEffects.Luststick)) + " час(ов) осталось\n";
				
			if (player.statusEffectv1(StatusEffects.LustStickApplied) > 0)
				statEffects += "Помада страсти нанесена - " + Math.round(player.statusEffectv1(StatusEffects.LustStickApplied)) + " час(ов) осталось\n";
				
			if (player.statusEffectv1(StatusEffects.LustyTongue) > 0)
				statEffects += "Страстный язычок - " + Math.round(player.statusEffectv1(StatusEffects.LustyTongue)) + " час(ов) осталось\n";
				
			if (player.statusEffectv1(StatusEffects.BlackCatBeer) > 0)
				statEffects += "Пиво 'Чёрный Кот' - " + player.statusEffectv1(StatusEffects.BlackCatBeer) + " час(ов) осталось (Стойкость к страсти понизилась на 20%, физическая стойкость повысилась на 25%.)\n";

			if (player.statusEffectv1(StatusEffects.AndysSmoke) > 0)
				statEffects += "Трубка Энди выкурена - " + player.statusEffectv1(StatusEffects.AndysSmoke) + " час(ов) осталось (Скорость временно снизилась, интеллект временно увеличился.)\n";
				
			if (player.statusEffectv1(StatusEffects.IzumisPipeSmoke) > 0) 
				statEffects += "Трубка Изуми выкурена - " + player.statusEffectv1(StatusEffects.IzumisPipeSmoke) + " час(ов) осталось (Скорость временно снизилась.)\n";

			if (player.statusEffectv1(StatusEffects.UmasMassage) > 0) 
				statEffects += "Массаж Умы - " + player.statusEffectv3(StatusEffects.UmasMassage) + " час(ов) осталось\n";
				
			if (player.statusEffectv1(StatusEffects.Dysfunction) > 0) 
				statEffects += "Дисфункция - " + player.statusEffectv1(StatusEffects.Dysfunction) + " час(ов) осталось (Помастурбировать не получится)\n";

			if (statEffects != "")
				outputText("\n<b><u>Продолжительные эффекты</u></b>\n" + statEffects);
			// End Ongoing Stat Effects
			menu();
			addButton(0, "Далее", playerMenu);
			if (player.statPoints > 0) {
				outputText("\n\n<b>У тебя " + num2Text(player.statPoints) + " очко" + (player.statPoints == 1 ? "" : "в") + " свойств, что можно потратить.</b>");
				addButton(1, "Улучшить", attributeMenu);
			}
		}
		
		//------------
		// PERKS
		//------------
		public function displayPerks():void {
			clearOutput();
			displayHeader("Навыки");
			for (var i:int = 0; i < player.perks.length; i++) {
				outputText("<b>" + player.perks[i].perkName + "</b> - " + player.perks[i].perkDesc + "\n");
			}
			menu();
			var button:int = 0;
			addButton(button++, "Далее", playerMenu);
			if (player.perkPoints > 0) {
				outputText("\n<b>У тебя " + num2Text(player.perkPoints) + " очко");
				if (player.perkPoints > 1) outputText("в");
				outputText(" навыков, что можно потратить.</b>");
				addButton(button++, "Навык↑", perkBuyMenu);
			}
			if (player.findPerk(PerkLib.DoubleAttack) >= 0) {
				outputText("\n<b>Ты можешь заглянуть в параметры двойных атак.</b>");
				addButton(button++,"Параметры атак",doubleAttackOptions);
			}
		
			if (player.findPerk(PerkLib.AscensionTolerance) >= 0){
				outputText("\n<b>Ты можешь заглянуть в параметры Терпимости к разврату.</b>");
				addButton(button++,"Параметры терпимости",ascToleranceOption,null,null,null,"Использовать или нет Терпимость к разврату.");
			}
			addButton(9, "База данных", perkDatabase);
		}

		public function doubleAttackOptions():void {
			clearOutput();
			menu();
			if (flags[kFLAGS.DOUBLE_ATTACK_STYLE] == 0) {
				outputText("Теперь ты будешь всегда атаковать дважды. Если твоя сила больше шестидесяти, то твоя двойная атака будет рассчитываться исходя из силы в шестьдесят.");
				outputText("\n\nТы можешь поставить двойные атаки, которые динамично переключаются на одиночные при силе в шестьдесят.");
				outputText("\nТы можешь выбрать постоянные одиночные атаки.");
			}
			else if (flags[kFLAGS.DOUBLE_ATTACK_STYLE] == 1) {
				outputText("Теперь ты будешь атаковать дважды - до тех пор, пока твоя сила не превысит шестидесяти, затем ты перейдешь на одиночные атаки.");
				outputText("\n\nТы можешь выбрать постоянную двойную атаку с уменьшенной силой (Когда сила больше шестидесяти - дает атаку с силой шестьдесят.)");
				outputText("\nТы можешь выбрать постоянные одиночные атаки.");
			}
			else {
				outputText("Теперь ты всегда атакуешь врагов одиночной атакой.");
				outputText("\n\nТы можешь выбрать постоянную двойную атаку с уменьшенной силой (Когда сила больше шестидесяти - дает атаку с силой шестьдесят.)");
				outputText("\nТы можешь поставить двойные атаки, которые динамично переключаются на одиночные при силе в шестьдесят.");
			}
			if (flags[kFLAGS.DOUBLE_ATTACK_STYLE] != 0) addButton(0, "Двойные", doubleAttackForce);
			if (flags[kFLAGS.DOUBLE_ATTACK_STYLE] != 1) addButton(1, "Динамичные", doubleAttackDynamic);
			if (flags[kFLAGS.DOUBLE_ATTACK_STYLE] != 2) addButton(2, "Одиночные", doubleAttackOff);
			addButton(4, "Назад", displayPerks);
		}

		public function doubleAttackForce():void {
			flags[kFLAGS.DOUBLE_ATTACK_STYLE] = 0;
			doubleAttackOptions();
		}
		public function doubleAttackDynamic():void {
			flags[kFLAGS.DOUBLE_ATTACK_STYLE] = 1;
			doubleAttackOptions();
		}
		public function doubleAttackOff():void {
			flags[kFLAGS.DOUBLE_ATTACK_STYLE] = 2;
			doubleAttackOptions();
		}
		
		public function ascToleranceOption():void{
			clearOutput();
			menu();
			if (player.perkv2(PerkLib.AscensionTolerance) == 0){
				outputText("Терпимость к разврату действует, давая тебе " + player.corruptionTolerance() + " терпимости на большинство развратных событий." +
				"\n\nТы можешь отключить действие этого навыка в любое время.<b>Некоторые сторонники могут немедленно покинуть твой лагерь, если ты это сделаешь. Сохранись заранее!</b>");
				addButton(0, "Отключить", disableTolerance);
			}else addButtonDisabled(0, "Отключить", "Этот навык уже отключен.");
			if (player.perkv2(PerkLib.AscensionTolerance) == 1){
				outputText("Терпимость к восхождению не действует. Ты можешь включить ее в любое время.");
				addButton(1, "Включить", enableTolerance);
			}else addButtonDisabled(1, "Включить", "Этот навык уже включен.");
			addButton(4, "Назад", displayPerks);
		}
		
		public function disableTolerance():void{
			player.setPerkValue(PerkLib.AscensionTolerance, 2, 1);
			ascToleranceOption();
		}
		public function enableTolerance():void{
			player.setPerkValue(PerkLib.AscensionTolerance, 2, 0);
			ascToleranceOption();
		}

		public function perkDatabase(page:int=0, count:int=20):void {
			var allPerks:Array = PerkTree.obtainablePerks();
			clearOutput();
			var perks:Array = allPerks.slice(page*count,(page+1)*count);
			displayHeader("Все навыки ("+(1+page*count)+"-"+(page*count+perks.length)+
					"/"+allPerks.length+")");
			for each (var ptype:PerkType in perks) {
				var pclass:PerkClass = player.perk(player.findPerk(ptype));

				var color:String;
				if (pclass) color='#000000'; // has perk
				else if (ptype.available(player)) color='#228822'; // can take on next lvl
				else color='#aa8822'; // requirements not met

				outputText("<font color='" +color +"'><b>"+ptype.name+"</b></font>: ");
				outputText(pclass?ptype.desc(pclass):ptype.longDesc);
				if (!pclass && ptype.requirements.length>0) {
					var reqs:Array = [];
					for each (var cond:Object in ptype.requirements) {
						if (cond.fn(player)) color='#000000';
						else color='#aa2222';
						reqs.push("<font color='"+color+"'>"+cond.text+"</font>");
					}
					outputText("<ul><li><b>Требуется:</b> " + reqs.join(", ")+".</li></ul>");
				} else {
					outputText("\n");
				}
			}
			if (page>0) addButton(0,"Предыдущее",perkDatabase,page-1);
			else addButtonDisabled(0,"Предыдущее");
			if ((page+1)*count<allPerks.length) addButton(1,"Далее",perkDatabase,page+1);
			else addButtonDisabled(1,"Далее");
			addButton(9, "Назад", playerMenu);
		}
		
		//------------
		// LEVEL UP
		//------------
		public function levelUpGo():void {
			clearOutput();
			hideMenus();
			//Level up
			if (player.XP >= player.requiredXP() && player.level < getGame().levelCap) {
				player.XP -= player.requiredXP();
				player.level++;
				player.perkPoints++;
				player.statPoints += 5;
				if (player.level % 2 == 0) player.ascensionPerkPoints++;
				outputText("<b>Теперь ты на " + num2Text(player.level) + "-м уровне!</b>\n\nТы получаешь пять очков свойств и один навык!");
				doNext(attributeMenu);
			}
			//Spend attribute points
			else if (player.statPoints > 0) {
				attributeMenu();
			}
			//Spend perk points
			else if (player.perkPoints > 0) {
				perkBuyMenu();
			}
			else {
				outputText("<b>ERROR.  LEVEL UP PUSHED WHEN PC CANNOT LEVEL OR GAIN PERKS.  PLEASE REPORT THE STEPS TO REPRODUCE THIS BUG TO FENOXO@GMAIL.COM OR THE FENOXO.COM BUG REPORT FORUM.</b>");
				doNext(playerMenu);
			}
		}

		//Attribute menu
		private function attributeMenu():void {
			clearOutput();
			outputText("У тебя <b>" + (player.statPoints) + "</b> осталось потратить.\n\n");
			
			outputText("Сила: ");
			if (player.str < player.getMaxStats("str")) outputText("" + Math.floor(player.str) + " + <b>" + player.tempStr + "</b> → " + Math.floor(player.str + player.tempStr) + "\n");
			else outputText("" + Math.floor(player.str) + " (MAX)\n");
			
			outputText("Стойкость: ");
			if (player.tou < player.getMaxStats("tou")) outputText("" + Math.floor(player.tou) + " + <b>" + player.tempTou + "</b> → " + Math.floor(player.tou + player.tempTou) + "\n");
			else outputText("" + Math.floor(player.tou) + " (MAX)\n");
			
			outputText("Скорость: ");
			if (player.spe < player.getMaxStats("spe")) outputText("" + Math.floor(player.spe) + " + <b>" + player.tempSpe + "</b> → " + Math.floor(player.spe + player.tempSpe) + "\n");
			else outputText("" + Math.floor(player.spe) + " (MAX)\n");
			
			outputText("Интеллект: ");
			if (player.inte < player.getMaxStats("int")) outputText("" + Math.floor(player.inte) + " + <b>" + player.tempInt + "</b> → " + Math.floor(player.inte + player.tempInt) + "\n");
			else outputText("" + Math.floor(player.inte) + " (MAX)\n");

			menu();
			//Add
			if (player.statPoints > 0) {
				if ((player.str + player.tempStr) < player.getMaxStats("str")) addButton(0, "СИЛ↑", addAttribute, "str", null, null, "Добавить 1 очко к силе.", "Увеличить силу");
				if ((player.tou + player.tempTou) < player.getMaxStats("tou")) addButton(1, "СТК↑", addAttribute, "tou", null, null, "Добавить 1 очко к стойкости.", "Увеличить стойкость");
				if ((player.spe + player.tempSpe) < player.getMaxStats("spe")) addButton(2, "СКОР↑", addAttribute, "spe", null, null, "Добавить 1 очко к скорости.", "Увеличить скорость");
				if ((player.inte + player.tempInt) < player.getMaxStats("int")) addButton(3, "ИНТ↑", addAttribute, "int", null, null, "Добавить 1 очко к интеллекту.", "Увеличить интеллект");
			}
			//Subtract
			if (player.tempStr > 0) addButton(5, "СИЛ↓", subtractAttribute, "str", null, null, "Отнять 1 очко от силы.", "Уменьшить силу");
			if (player.tempTou > 0) addButton(6, "СТК↓", subtractAttribute, "tou", null, null, "Отнять 1 очко от стойкости.", "Уменьшить стойкость");
			if (player.tempSpe > 0) addButton(7, "СКОР↓", subtractAttribute, "spe", null, null, "Отнять 1 очко от скорости.", "Уменьшить скорость");
			if (player.tempInt > 0) addButton(8, "ИНТ↓", subtractAttribute, "int", null, null, "Отнять 1 очко от интеллекта.", "Уменьшить интеллект");
			
			addButton(4, "Заново", resetAttributes);
			addButton(9, "Закончить", finishAttributes);
		}

		private function addAttribute(attribute:String):void {
			switch(attribute) {
				case "str":
					player.tempStr++;
					break;
				case "tou":
					player.tempTou++;
					break;
				case "spe":
					player.tempSpe++;
					break;
				case "int":
					player.tempInt++;
					break;
				default:
					player.statPoints++; //Failsafe
			}
			player.statPoints--;
			attributeMenu();
		}
		private function subtractAttribute(attribute:String):void {
			switch(attribute) {
				case "str":
					player.tempStr--;
					break;
				case "tou":
					player.tempTou--;
					break;
				case "spe":
					player.tempSpe--;
					break;
				case "int":
					player.tempInt--;
					break;
				default:
					player.statPoints--; //Failsafe
			}
			player.statPoints++;
			attributeMenu();
		}
		private function resetAttributes():void {
			//Increment unspent attribute points.
			player.statPoints += player.tempStr;
			player.statPoints += player.tempTou;
			player.statPoints += player.tempSpe;
			player.statPoints += player.tempInt;
			//Reset temporary attributes to 0.
			player.tempStr = 0;
			player.tempTou = 0;
			player.tempSpe = 0;
			player.tempInt = 0;
			//DONE!
			attributeMenu();
		}
		private function finishAttributes():void {
			clearOutput()
			if (player.tempStr > 0)
			{
				if (player.tempStr >= 3) outputText("Ты ощущаешь, что за время твоих приключений - твои мышцы стали куда сильнее.\n");
				else outputText("Ты ощущаешь, что за время твоих приключений - твои мышцы стали немного сильнее.\n");
			}
			if (player.tempTou > 0)
			{
				if (player.tempTou >= 3) outputText("Ты чувствуешь себя более выносливее после всех боев, что тебе удалось пережить.\n");
				else outputText("Ты чувствуешь себя чуть более выносливее после всех боев, что тебе удалось пережить.\n");
			}
			if (player.tempSpe > 0)
			{
				if (player.tempSpe >= 3) outputText("Время, проведенное в поединках, ускорило твои рефлексы.\n");
				else outputText("Время, проведенное в поединках, немного ускорило твои рефлексы.\n");
			}
			if (player.tempInt > 0)
			{
				if (player.tempInt >= 3) outputText("Время, проведенное в сражениях с созданиями этого мира, обострило твой ум.\n");
				else outputText("Время, проведенное в сражениях с созданиями этого мира, немного обострило твой ум.\n");
			}
			if (player.tempStr + player.tempTou + player.tempSpe + player.tempInt <= 0 || player.statPoints > 0)
			{
				outputText("\nТы можешь распределить очки своего статуса позже.");
			}
			dynStats("str", player.tempStr, "tou", player.tempTou, "spe", player.tempSpe, "int", player.tempInt, "noBimbo", true); //Ignores bro/bimbo perks.
			player.tempStr = 0;
			player.tempTou = 0;
			player.tempSpe = 0;
			player.tempInt = 0;
			if (player.perkPoints > 0)
				doNext(perkBuyMenu);
			else
				doNext(playerMenu);
		}
		
		//Perk menu
		private function perkBuyMenu():void {
			clearOutput();
			var perkList:Array = buildPerkList();
			mainView.aCb.dataProvider = new DataProvider(perkList);
			if (perkList.length == 0) {
				outputText("<b>В настоящий момент у тебя нет подготовки для получения какого-либо навыка. </b>Несмотря на твою подготовку, при тебе всегда буд");
				if (player.perkPoints > 1) outputText("ут эти " + num2Text(player.perkPoints) + " очки навыков.");
				else outputText("ет это " + num2Text(player.perkPoints) + " очко навыков.");
				doNext(playerMenu);
				return;
			}
			outputText("Выбери навык из выпадающего списка, затем нажми 'Окей'. Ты можешь нажать 'Пропустить', чтобы оставить свое очко навыка на потом.\n\n\n");
			mainView.aCb.x = 210;
			mainView.aCb.y = 112;
			
			if (mainView.aCb.parent == null) {
				mainView.addChild(mainView.aCb);
			}
			mainView.aCb.visible = true;
			menu();
			addButton(1, "Пропустить", perkSkip);
		}
		private function perkSelect(selected:PerkClass):void {
			mainView.stage.focus = null;
			if (mainView.aCb.parent != null) {
				mainView.removeChild(mainView.aCb);
				applyPerk(selected);
			}
		}
		private function perkSkip():void {
			mainView.stage.focus = null;
			if (mainView.aCb.parent != null) {
				mainView.removeChild(mainView.aCb);
				playerMenu();
			}
		}

		public function changeHandler(event:Event):void {
			//Store perk name for later addition
			clearOutput();
			var selected:PerkClass = ComboBox(event.target).selectedItem.perk;
			mainView.aCb.move(210, 85);
			outputText("Ты выбираешь следующий навык:\n\n\n");
			outputText("<b>" + selected.perkName + ":</b> " + selected.perkLongDesc);
			var unlocks:Array = kGAMECLASS.perkTree.listUnlocks(selected.ptype);
			if (unlocks.length>0){
				outputText("\n\n<b>Разблокирует:</b> <ul>");
				for each (var pt:PerkType in unlocks) outputText("<li><b>"+pt.name+"</b> ("+pt.longDesc+")</li>");
				outputText("</ul>");
			}
			outputText("\n\nЕсли хочешь выбрать именно этот навык, нажми <b>Хорошо</b>. В другом случае, выбери новый, или нажми <b>Пропустить</b>, чтобы решить позже.");
			menu();
			addButton(0, "Окей", perkSelect, selected);
			addButton(1, "Пропустить", perkSkip);
		}

		public function buildPerkList():Array {
			var player:Player  = kGAMECLASS.player;
			var perks:Array = PerkTree.availablePerks(player);
			var perkList:Array = [];
			for each(var perk:PerkType in perks) {
				var p:PerkClass = new PerkClass(perk,
						perk.defaultValue1, perk.defaultValue2, perk.defaultValue3, perk.defaultValue4);
				perkList.push({label: p.perkName, perk: p});
			}
			return perkList;
		}
		public function applyPerk(perk:PerkClass):void {
			clearOutput();
			player.perkPoints--;
			//Apply perk here.
			outputText("<b>" + perk.perkName + "</b> получен!");
			player.createPerk(perk.ptype, perk.value1, perk.value2, perk.value3, perk.value4);
			if (perk.ptype == PerkLib.StrongBack2) player.itemSlot5.unlocked = true;
			if (perk.ptype == PerkLib.StrongBack) player.itemSlot4.unlocked = true;
			if (perk.ptype == PerkLib.Tank2) {
				HPChange(player.tou, false);
				statScreenRefresh();
			}
			doNext(playerMenu);
		}
	}

}
