Alter table leaves add  free_day enum('monday','tuesday','wednesday','thursday','friday') default null;
Alter table leaves add parent_leave_id int(11) default null;
Alter table leaves add parent_leave bool default 0;
ALTER  table  leaves add sub_leaves_treated bool default 0;

Alter table leaves_history add  free_day enum('monday','tuesday','wednesday','thursday','friday') default null;
Alter table leaves_history add parent_leave_id int(11) default null;
Alter table leaves_history add parent_leave bool default 0;
ALTER table leaves_history add sub_leaves_treated bool default 0;

Alter table types add auto_confirm bool default 0;