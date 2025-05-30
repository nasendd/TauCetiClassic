//Bit flags for the flags_inv variable, which determine when a piece of clothing hides another. IE a helmet hiding glasses.
//Make sure to update check_obscured_slots() if you add more.
#define HIDEGLOVES        (1<<0)
#define HIDESUITSTORAGE   (1<<1)
#define HIDEJUMPSUIT      (1<<2)	// These first four are only used in exterior suits.
#define HIDESHOES         (1<<3)
#define HIDEMASK          (1<<4)	// these four are only used in masks and headgear,
#define HIDEEARS          (1<<5)	// (ears means headsets and such),
#define HIDEEYES          (1<<6)	// whether eyes and glasses are hidden,
#define HIDEFACE          (1<<7)	// whether we appear as unknown.

// render_flags bitmask, affects render but not access
// todo: move it to mob traits when Lummox allow us init list manipulations
#define HIDE_TAIL         (1<<0)
#define HIDE_WINGS        (1<<1)
#define HIDE_UNIFORM      (1<<2)
#define HIDE_TOP_HAIR     (1<<3) // replaced BLOCKHEADHAIR, stops hair from rendering
#define HIDE_FACIAL_HAIR  (1<<4)
#define HIDE_ALL_HAIR     (HIDE_TOP_HAIR | HIDE_FACIAL_HAIR) // replaced BLOCKHAIR

//ITEM INVENTORY SLOT BITMASKS
#define SLOT_FLAGS_OCLOTHING    (1<<0)
#define SLOT_FLAGS_ICLOTHING    (1<<1)
#define SLOT_FLAGS_GLOVES       (1<<2)
#define SLOT_FLAGS_EYES         (1<<3)
#define SLOT_FLAGS_EARS         (1<<4)
#define SLOT_FLAGS_MASK         (1<<5)
#define SLOT_FLAGS_HEAD         (1<<6)
#define SLOT_FLAGS_FEET         (1<<7)
#define SLOT_FLAGS_ID           (1<<8)
#define SLOT_FLAGS_BELT         (1<<9)
#define SLOT_FLAGS_BACK         (1<<10)
#define SLOT_FLAGS_POCKET       (1<<11)    // This is to allow items with a w_class of 3 or 4 to fit in pockets.
#define SLOT_FLAGS_DENYPOCKET   (1<<12)    // This is to deny items with a w_class of 2 or 1 to fit in pockets.
#define SLOT_FLAGS_TWOEARS      (1<<13)
#define SLOT_FLAGS_TIE          (1<<14)
#define SLOT_FLAGS_NECK         (1<<15)

//slots
#define SLOT_BACK          1
#define SLOT_WEAR_MASK     2
#define SLOT_HANDCUFFED    3
#define SLOT_L_HAND        4
#define SLOT_R_HAND        5
#define SLOT_BELT          6
#define SLOT_WEAR_ID       7
#define SLOT_L_EAR         8
#define SLOT_R_EAR         9
#define SLOT_GLASSES       10
#define SLOT_GLOVES        11
#define SLOT_HEAD          12
#define SLOT_SHOES         13
#define SLOT_WEAR_SUIT     14
#define SLOT_W_UNIFORM     15
#define SLOT_L_STORE       16
#define SLOT_R_STORE       17
#define SLOT_S_STORE       18
#define SLOT_IN_BACKPACK   19
#define SLOT_LEGCUFFED     20
#define SLOT_TIE           21
#define SLOT_EARS          22 // Used in obscured checks
#define SLOT_NECK          23

//sprite sheet slot types(as also seen in update_icon.dm)
#define SPRITE_SHEET_HELD "held"
#define SPRITE_SHEET_UNIFORM "uniform"
#define SPRITE_SHEET_UNIFORM_FAT "uniform_fat"
#define SPRITE_SHEET_SUIT "suit"
#define SPRITE_SHEET_SUIT_FAT "suit_fat"
#define SPRITE_SHEET_BELT "belt"
#define SPRITE_SHEET_HEAD "head"
#define SPRITE_SHEET_BACK "back"
#define SPRITE_SHEET_MASK "mask"
#define SPRITE_SHEET_EARS "ears"
#define SPRITE_SHEET_EYES "eyes"
#define SPRITE_SHEET_FEET "feet"
#define SPRITE_SHEET_GLOVES "gloves"
#define SPRITE_SHEET_NECK "neck"

#define OFFSET_UNIFORM "uniform"
#define OFFSET_ID "id"
#define OFFSET_GLOVES "gloves"
#define OFFSET_GLASSES "glasses"
#define OFFSET_EARS "ears"
#define OFFSET_SHOES "shoes"
#define OFFSET_S_STORE "s_store"
#define OFFSET_FACEMASK "mask"
#define OFFSET_HEAD "head"
#define OFFSET_FACE "face"
#define OFFSET_BELT "belt"
#define OFFSET_BACK "back"
#define OFFSET_SUIT "suit"
#define OFFSET_NECK "neck"
#define OFFSET_HELD "held"
#define OFFSET_ACCESSORY "accessory"
#define OFFSET_HAIR "hair"

//Sol translation for dog slots.
#define SLOT_MOUTH SLOT_WEAR_MASK  // 2
#define SLOT_IAN_NECK  SLOT_HANDCUFFED // 3 (Ian actually is a cat! ~if you know what i mean)

//Cant seem to find a mob bitflags area other than the powers one

// bitflags for clothing parts
#define HEAD (1<<0)
#define FACE (1<<1)
#define EYES (1<<2)
#define UPPER_TORSO (1<<3)
#define LOWER_TORSO (1<<4)
#define LEG_LEFT (1<<5)
#define LEG_RIGHT (1<<6)
#define LEGS (LEG_LEFT | LEG_RIGHT)
#define ARM_LEFT (1<<7)
#define ARM_RIGHT (1<<8)
#define ARMS (ARM_LEFT | ARM_RIGHT)
#define FULL_BODY ALL

// How much coverage(in percents) of each clothing part covers our body(aproximately)
#define HEAD_COVERAGE    5
#define FACE_COVERAGE    2
#define EYES_COVERAGE    2
#define MOUTH_COVERAGE   1
#define CHEST_COVERAGE   30
#define GROIN_COVERAGE   20
#define ARMS_COVERAGE    10
#define LEGS_COVERAGE    10

// Flash protection
// Used in eyecheck() on flashes, welders and etc. More - better, less - more damage
#define FLASHES_FULL_PROTECTION 2
#define FLASHES_PARTIAL_PROTECTION 1
#define FLASHES_AMPLIFIER -1

// bitflags for the percentual amount of protection a piece of clothing which covers the body part offers.
// Used with human/proc/get_heat_protection() and human/proc/get_cold_protection()
// The values here should add up to 1.
// arms and legs 10%, each of the torso parts has 15% and the head has 30%
#define THERMAL_PROTECTION_HEAD			0.3
#define THERMAL_PROTECTION_UPPER_TORSO	0.15
#define THERMAL_PROTECTION_LOWER_TORSO	0.15
#define THERMAL_PROTECTION_LEG_LEFT		0.1
#define THERMAL_PROTECTION_LEG_RIGHT	0.1
#define THERMAL_PROTECTION_ARM_LEFT		0.1
#define THERMAL_PROTECTION_ARM_RIGHT	0.1

// Suit sensor levels
#define SUIT_SENSOR_OFF      0
#define SUIT_SENSOR_BINARY   1
#define SUIT_SENSOR_VITAL    2
#define SUIT_SENSOR_TRACKING 3

// Cutting shoes flags

#define NO_CLIPPING   -1
#define CLIPPABLE      0
#define CLIPPED        1

// attack_reaction types
#define REACTION_INTERACT_UNARMED 0
#define REACTION_INTERACT_ARMED 1
#define REACTION_GUN_FIRE 2
#define REACTION_ITEM_TAKE 3
#define REACTION_ITEM_TAKEOFF 4
#define REACTION_HIT_BY_BULLET 5
#define REACTION_ATACKED 6
#define REACTION_THROWITEM 7

// Hardsuit mount places. Used to limit subtypes of the same module
#define MODULE_MOUNT_AI 				1
#define MODULE_MOUNT_GRENADELAUNCHER 	2
#define MODULE_MOUNT_SHOULDER_RIGHT 	4
#define MODULE_MOUNT_SHOULDER_LEFT 		8
#define MODULE_MOUNT_INJECTOR 			16
#define MODULE_MOUNT_CHEST 				32

// Rig module damage levels
#define MODULE_NO_DAMAGE 0
#define MODULE_DAMAGED 1
#define MODULE_DESTROYED 2
