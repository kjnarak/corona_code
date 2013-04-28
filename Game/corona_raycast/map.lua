-- Project: Raycasting Engine Demo
-- SDK: Corona - 09/12/11
-- Author: Andrew Burch
-- Date: 08/02/2012
-- Site: http://www.newhighscore.net
-- Contact: andrew.burch@newhighscore.net
-- Note: Map data and variables

module(..., package.seeall)

rowCount = 10
columnCount = 10

mapData = {
	{1,2,3,4,1,2,3,4,1,1},
	{1,0,0,4,0,0,0,0,0,2},
	{2,0,0,2,2,0,0,0,3,3},
	{3,0,0,5,0,0,0,0,0,2},
	{2,0,0,1,2,3,1,0,0,4},
	{1,0,0,0,4,0,0,0,0,2},
	{2,0,0,0,5,0,0,0,5,3},
	{3,3,0,0,0,0,0,0,0,2},
	{2,0,0,0,2,0,0,3,0,1},
	{1,1,2,3,2,1,2,3,2,1},
}

wallDefList = {
	{
		textureId = 'wall1',
		isSolid = true,
	},
	{
		textureId = 'wall2',
		isSolid = true,
	},
	{
		textureId = 'wall3',
		isSolid = true,
	},
	{
		textureId = 'wall4',
		isSolid = true,
	},
	{
		textureId = 'wall5',
		isSolid = true,
	},
}
