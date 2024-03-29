﻿#Область Механизм_Подключения_Дополнительного_Отчета_Обработки

// Для внутреннего использования. Сведения для регистрации отчета.
Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = Новый Структура;
	ПараметрыРегистрации.Вставить("Вид",             ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка()); // Варианты: "ДополнительнаяОбработка", "ДополнительныйОтчет", 
																			 // "ЗаполнениеОбъекта", "Отчет", "ПечатнаяФорма", "СозданиеСвязанныхОбъектов" 
	
	ПараметрыРегистрации.Вставить("Наименование",    "Внешняя обработка: " + Метаданные().Синоним);
	ПараметрыРегистрации.Вставить("Версия",          "1.40");			// версия внешней обработки.
	ПараметрыРегистрации.Вставить("БезопасныйРежим", Ложь); 			// если ИСТИНА, то выводится конфигураторская ошибка в типовой реализации,
																		// связанная с ограничениями при использовании компоненты в механизмах внешних отчетов и обработок.
	ПараметрыРегистрации.Вставить("Информация",      "Разработчик: Попов М.М.(тел. 8-952-889-7533, e-mail: m.popov@kdvm.ru)
	|2022-03-23: Добавил возможность ручного изменения даты выгрузки в заказе Каргомарт (Попов М.М.)");
	ПараметрыРегистрации.Вставить("ВерсияБСП",       "2.3.5.29"); 		// не ниже какой версии БСП подерживается обработка
	
	// Команды формирования отчета:
	ТаблицаКоманд = Новый ТаблицаЗначений;
	ТаблицаКоманд.Колонки.Добавить("Представление",         Новый ОписаниеТипов("Строка"));
	ТаблицаКоманд.Колонки.Добавить("Идентификатор",         Новый ОписаниеТипов("Строка"));
	ТаблицаКоманд.Колонки.Добавить("Использование",         Новый ОписаниеТипов("Строка"));
	ТаблицаКоманд.Колонки.Добавить("ПоказыватьОповещение",  Новый ОписаниеТипов("Булево"));
	ТаблицаКоманд.Колонки.Добавить("Модификатор",           Новый ОписаниеТипов("Строка"));
	
	// 
	ДобавитьКоманду(ТаблицаКоманд,
					"Проверка сканов",
					"ПроверкаСканов",
					ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовКлиентскогоМетода(),
					Ложь,				//Показывать оповещение. Варианты Истина, Ложь.
					"");				//Модификатор.
					
	ДобавитьКоманду(ТаблицаКоманд,
					"Проверка оригиналов",
					"ПроверкаОригиналов",
					ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовКлиентскогоМетода(),
					Ложь,				
					"");				
					
	ДобавитьКоманду(ТаблицаКоманд,
					"Проверка сканов (протокол v1)",
					"ПроверкаСкановПротокол_V1",
					ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовКлиентскогоМетода(),
					Ложь,				//Показывать оповещение. Варианты Истина, Ложь.
					"");				//Модификатор.
					
	ДобавитьКоманду(ТаблицаКоманд,
					"Проверка оригиналов (протокол v1)",
					"ПроверкаОригиналовПротокол_V1",
					ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовКлиентскогоМетода(),
					Ложь,				
					"");				
					
	ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
	
	Возврат ПараметрыРегистрации;
	
КонецФункции // СведенияОВнешнейОбработке()

// Добавляет команды в таблицу.
Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "")

	НоваяКоманда = ТаблицаКоманд.Добавить();
	НоваяКоманда.Представление        = Представление;
	НоваяКоманда.Идентификатор        = Идентификатор;
	НоваяКоманда.Использование        = Использование;
	НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
	НоваяКоманда.Модификатор          = Модификатор;

КонецПроцедуры // ДобавитьКоманду()

// Выполнение команд для нефайловой базы.
// ИдентификаторКоманды - вызываемая команда: "СформироватьОтчет".
Процедура ВыполнитьКоманду(ИдентификаторКоманды, ПараметрыКоманды) Экспорт
	
	//Выполнить(ИдентификаторКоманды + "(ПараметрыКоманды.ПараметрыОтчета, ПараметрыКоманды.АдресХранилища)");
	//
	//ПараметрыКоманды.Вставить("ЗаданиеВыполнено",     Истина);
	//ПараметрыКоманды.Вставить("ИдентификаторЗадания", Неопределено);
	
КонецПроцедуры

#КонецОбласти // Механизм_Подключения_Дополнительного_Отчета_Обработки
