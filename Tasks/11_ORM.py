from sqlalchemy import create_engine, Column, Integer, String, DECIMAL, ForeignKey, TIMESTAMP, Boolean, func
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

Base = declarative_base()


class GameName(Base):
    tablename = 'game_name'
    game_name = Column(String, primary_key=True)
    players_in_team = Column(Integer)
    developer = Column(String)


engine = create_engine('postgresql+psycopg2://username:password@host:port/database')
Session = sessionmaker(bind=engine)
session = Session()


def crud_operations():
    new_game = GameName(game_name="New Game", players_in_team=5, developer="New Dev")
    session.add(new_game)
    session.commit()

    games = session.query(GameName).all()
    for game in games:
        print(game.game_name)

    game_to_update = session.query(GameName).filter(GameName.game_name == "New Game").first()
    game_to_update.developer = "Updated Dev"
    session.commit()

    game_to_delete = session.query(GameName).filter(GameName.game_name == "New Game").first()
    session.delete(game_to_delete)
    session.commit()


def analytical_queries():
    team_count = session.query(func.count(Team.team_id)).scalar()
    print(f"Total number of teams: {team_count}")

    matches = session.query(Match, Team).join(Team, Match.team_1 == Team.team_id).all()
    for match, team in matches:
        print(f"Match ID: {match.match_id}, Team: {team.team_name}")


crud_operations()
analytical_queries()
session.close()
