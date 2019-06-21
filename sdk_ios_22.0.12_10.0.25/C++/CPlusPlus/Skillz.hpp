//
//  Skillz.hpp
//  SkillzSDK-iOS
//
//  Copyright (c) 2014 Skillz. All rights reserved.
//  http://skillz.com/
//
//  Version %version%
//

#ifndef SkillzSDK_iOS_Skillz_hpp
#define SkillzSDK_iOS_Skillz_hpp

#include <stdint.h>

#include <string>
#include <map>

namespace skillz {

typedef int64_t GameId;
typedef int64_t PlayerId;
    
class BaseDelegateInterface;
class DelegateInterface;
class Random;
class Player;
    
enum Environment {
    kSandBoxEnvironment = 0,
    kProductionEnvironment
};
    
enum Orientation {
    kPortraitOrientation,
    kLandscapeOrientation
};

/**
 * Skillz static methods
 *
 */

class Skillz final {
public:
    /** Initializes the Skillz SDK. Should be called shortly after application launch
     
     @param delegate a pointer to an DelegateInterface object provided by the applicatoin
     
     */
    static void             Init( DelegateInterface* delegate );
    
    /** Launches the Skillz experience.
     */
    static void             Launch();
    
    /** Returns the version of the Skillz SDK
     */
    static std::string      Version();
    
    /** Returns a pointer to a Player object representing the (local) Skillz player.
     */
    static Player*          Player();
};

class Player final {
public:
    /** Returns the url for the player's image (avatar)
     */
    std::string     AvatarUrl() const;
    
    /** Returns the player's Skillz display name
     */
    std::string     DisplayName() const;
    
    /** Returns a URL for the player's national flag
     */
    
    std::string     FlagUrl() const;
    /** Returns the Skillz player id which can be used to identify a user unambiguously
     */
    std::string     PlayerId() const;
};

class Match final {
public:
    /** Returns the unique id for this particular match
     */
    int64_t         Id();
    
    /** Identifies the template that was used to generate this match
     */
    int64_t         TemplateId();
    
    /** Returns a pointer to the local player who participated in this match
     */
    Player*         Player();
    
    /** Returns the descirption of this match from the template
     */
    std::string     Description();
    
    /** Returns the name of this match from the template
     */
    std::string     Name();
    
    /** Returns whether this match has a cash prize
     */
    bool            isCash();
    
    /** Returns the number of 'Z' points (if any) required to enter this match 
     */
    int32_t         EntryPoints();
    
    /** Returns the amount of real money (if any) needed to enther this match
     */
    float           EntryCash();
    
    /** Retuns the game specific parameters as a std::map that are defined on the server for this match
     */
    std::map<std::string, std::string>* GameParameters();
    
    /** Returns a random number generator object that should be used to generate any random sequences reguired in this match */
    Random*         Random();
    
    /** Called by the application when the player forfeits that match 
     */
    void            Abort();
    
    /** Called periodically by the application to report any interim score. Used as an anti-cheating measure.
     */
    void            UpdateInterimScore(float score);
    
    /** Called when that match has ended.
     @param finalScore the score of the local player for this match
     */
    void            Finish(float finalScore);
    
    /** Returns whether this match is currently in progress.
     */
    bool            IsInProgress();
};
    
/** A Random number generator object. Should be used by application to generate any random sequence affecting the game's fairness
*/

class Random final
{
public:
    /** Returns the next randomly generated number
     */
    int32_t Next();
    
    /** Returns a randomly generated number equally distributed over the range
     includeMin (inclusive to exclusiveMax (exclusive)
     */
    int32_t Next(int32_t inclusiveMin, int32_t exclusiveMax);
};
/** 
    The interface for the application provided delegate object
 */
class BaseDelegateInterface
{
public:
    /** Invoked shortly after the application has launched the Skillz experience
     */
    virtual void BeforeSkillzLaunch()        = 0;

    /** Invoked after the player has aborted (forfeited) a match
     */
    virtual void AfterMatchAborted()         = 0;
    
    /** Invoked shortly before the user exits the Skillz experience
     */
    virtual void BeforeSkillzlExit()         = 0;
    
    /** Should return the Skillz-provided game id used by the Skillz server to identify that application
     */
    virtual GameId GameId()           = 0;
    
    /** Should return the desired environment (sandbox or production) for the application
     */
    virtual Environment Environment() = 0;
    
    /** Should return the orientation (portrait or landscape) of the application.
     */
    virtual Orientation Orientation() = 0;
};
    
class DelegateInterface : public BaseDelegateInterface
{
public:
    /** Invoked before a match begins. The application should run the game from within this method
     */
    virtual void BeforeMatch(Match* match)    = 0;
    
    /** Invoked when a match has concluded
     */
    virtual void AfterMatch(Match* match)     = 0;
};
    
}
#endif
