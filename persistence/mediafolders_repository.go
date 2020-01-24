package persistence

import (
	"github.com/astaxie/beego/orm"
	"github.com/deluan/navidrome/conf"
	"github.com/deluan/navidrome/model"
)

type mediaFolderRepository struct {
	model.MediaFolderRepository
}

func NewMediaFolderRepository(o orm.Ormer) model.MediaFolderRepository {
	return &mediaFolderRepository{}
}

func (*mediaFolderRepository) GetAll() (model.MediaFolders, error) {
	mediaFolder := model.MediaFolder{ID: "0", Path: conf.Server.MusicFolder}
	mediaFolder.Name = "Music Library"
	result := make(model.MediaFolders, 1)
	result[0] = mediaFolder
	return result, nil
}

var _ model.MediaFolderRepository = (*mediaFolderRepository)(nil)
