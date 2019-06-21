//
//  Skillz.mm
//  SkillzSDK-iOS
//
//  Copyright (c) 2015 Skillz. All rights reserved.
//

#include <stdio.h>

#import <SkillzSDK-iOS/Skillz.h>

#include "Skillz.hpp"

using skillz::Skillz;
using skillz::Player;
using skillz::BaseDelegateInterface;
using skillz::Match;
using skillz::Random;


namespace  {
    skillz::Player* skillzPlayer;
    Random * skillzRandom;
    std::map<std::string, std::string> gameParameters;
}

@interface CSkillzDelegate : NSObject <SkillzDelegate>

@property (nonatomic)  skillz::DelegateInterface* skillzDelegate;

@end

static CSkillzDelegate* cSkillzDelegate;
static skillz::Match* sMatch;

@implementation CSkillzDelegate

-(void)tournamentWillBegin:(NSDictionary *)gameParams
             withMatchInfo:(SKZMatchInfo *)matchInfo;
{
    gameParameters.clear();
    
    for (NSString* key in gameParams) {
        gameParameters[ std::string([key UTF8String])] = std::string([gameParams[key] UTF8String]);
    }
    
    if (!sMatch) {
        sMatch = new skillz::Match;
    }
    cSkillzDelegate.skillzDelegate->BeforeMatch(sMatch);
}

- (SkillzOrientation)preferredSkillzInterfaceOrientation
{
    return SkillzOrientation(self.skillzDelegate->Orientation());
}

- (void)skillzWillExit
{
    self.skillzDelegate->BeforeSkillzlExit();
}

- (void)skillzWillLaunch
{
}

- (void)skillzHasFinishedLaunching
{
}

@end


static SKZMatchInfo* currentMatchInfo;

// class Skillz

void skillz::Skillz::Init( skillz::DelegateInterface* delegate )
{
    cSkillzDelegate = [[CSkillzDelegate alloc] init];
    cSkillzDelegate.skillzDelegate = delegate;
    
    NSString* gameId = [NSString stringWithFormat:@"%lld", delegate->GameId()];
    
    [[::Skillz skillzInstance] initWithGameId:gameId forDelegate:cSkillzDelegate
                              withEnvironment:SkillzEnvironment(delegate->Environment())];
}

void skillz::Skillz::Launch()
{
    [[::Skillz skillzInstance] launchSkillz];
}
    
std::string skillz::Skillz::Version()
{
    std::string result([[::Skillz SDKShortVersion] UTF8String]);
    
    return result;
}

Player* Player()
{
    if (!skillzPlayer) {
        skillzPlayer = new skillz::Player;
    }
    return skillzPlayer;
}

// class Player

std::string Player::AvatarUrl() const
{
    std::string result;
 
    SKZPlayer* player = [::Skillz  player];
    
    if (player) {
        result = [[player avatarURL] UTF8String];
    }
    return result;
}

std::string Player::DisplayName() const
{
    std::string result;
    
    SKZPlayer* player = [::Skillz  player];
    
    if (player) {
        result = [[player displayName] UTF8String];
    }
    return result;
}

std::string Player::FlagUrl() const
{
    std::string result;
    
    SKZPlayer* player = [::Skillz  player];
    
    if (player) {
        result = [[player flagURL] UTF8String];
    }
    return result;
}

std::string Player::PlayerId() const
{
    std::string result;
    
    SKZPlayer* player = [::Skillz  player];
    
    if (player) {
        result = [[player id] UTF8String];
    }
    return result;
}

// class Match

int64_t Match::Id()
{
    return [currentMatchInfo id];
}

int64_t Match::TemplateId()
{
    return [[currentMatchInfo templateId] longLongValue];
}

class Player*  Match::Player()
{
    if (!skillzPlayer) {
        skillzPlayer = new skillz::Player;
    }
    return skillzPlayer;
}

std::string Match::Description()
{
    std::string result([[currentMatchInfo matchDescription] UTF8String]);
    
    return result;
}

std::string Match::Name()
{
    std::string result([[currentMatchInfo name] UTF8String]);
    
    return result;
}

bool Match::isCash()
{
    return [currentMatchInfo isCash];
}

int32_t Match::EntryPoints()
{
    return [[currentMatchInfo entryPoints] intValue];
}

float Match::EntryCash()
{
    return [[currentMatchInfo entryCash] floatValue];
}

std::map<std::string, std::string>*  Match::GameParameters()
{
    return &gameParameters;
}

Random* Match::Random()
{
    if (!skillzRandom) {
        skillzRandom = new skillz::Random;
    }
    return skillzRandom;
}

void Match::Abort()
{
    [[::Skillz skillzInstance] notifyPlayerAbortWithCompletion:^{
        cSkillzDelegate.skillzDelegate->AfterMatchAborted();
    }];
}

void Match::UpdateInterimScore(float score)
{
    [[::Skillz skillzInstance] updatePlayersCurrentScore:@(score)];
}

void Match::Finish(float finalScore)
{
    [[::Skillz skillzInstance] displayTournamentResultsWithScore:@(finalScore)
                                                  withCompletion:^{
                                                      cSkillzDelegate.skillzDelegate->AfterMatch(sMatch);
                                                  }];
}

bool Match::IsInProgress()
{
    return [::Skillz skillzInstance].tournamentIsInProgress;
}

int32_t Random::Next()
{
    return int32_t([::Skillz getRandomNumber]);
}

int32_t Random::Next(int32_t inclusiveMin, int32_t exclusiveMax)
{
    return  int32_t([::Skillz getRandomNumberWithMin:inclusiveMin andMax:exclusiveMax]);
}
