use master
create database QL_CHBACHHOATH
drop database QL_CHBACHHOATH
EXEC sp_changedbowner 'sa';
use QL_CHBACHHOATH

--Loại (Category): Là danh mục chính của các sản phẩm, như Sữa , Bánh kẹo các loại ,đồ dùng gia đình , chăm sóc cá nhân, vệ sinh nhà cửa  v.v.
create table LOAI(
	MALOAI int identity(1,1) primary key,
	TENLOAI nvarchar(100) NOT NULL,
);

--Phân loại (Subcategory): Là danh mục con trong một loại ví dụ Sữa : sữa tươi, sữa bột
create table PHANLOAI(
	MAPHANLOAI int identity(1,1) primary key,
	TENPHANLOAI nvarchar(100) NOT NULL,
	MALOAI int,
	constraint FK_PHANLOAI_LOAI foreign key (MALOAI) references LOAI(MALOAI),

);

create table SANPHAM(
	MASP int identity(1,1) primary key,
	TENSP nvarchar(255) NOT NULL,
	THUONGHIEU nvarchar(255),
	GIA	money check (GIA > 0),
	MOTA nvarchar(MAX),
	HINHANH nvarchar(MAX),
	TONKHO int,
	MAPHANLOAI int,
	constraint FK_SANPHAM_PHANLOAI foreign key (MAPHANLOAI) references PHANLOAI(MAPHANLOAI),
);

create table NHANVIEN
(
	MANV int identity(1,1) primary key,
	TENNV nvarchar(100) NOT NULL,
	SDT char(11),
	GIOITINH nchar(5) check (GIOITINH = N'Nữ' or GIOITINH = N'Nam'),
	NGAYSINH date,
	DIACHI nvarchar(151),
	HINHANH nvarchar(MAX),
);

create table PHANQUYEN
(
	ID int primary key,
	QUYEN nvarchar(50) NOT NULL
);

create table TAIKHOAN
(
	MATK int identity(1,1) primary key,
	TAIKHOAN varchar(50) UNIQUE,
	MATKHAU varchar(255) NOT NULL,
	MANV int,
	ID_ROLE int,
	constraint FK_TAIKHOAN_NHANVIEN foreign key (MANV) references NHANVIEN(MANV),
	constraint FK_TAIKHOAN_PHANQUYEN foreign key (ID_ROLE) references PHANQUYEN(ID),
);

create table KHACHHANG(
	MAKH int identity(1,1) primary key,
	TENKH nvarchar(100) NOT NULL,
	EMAIL nvarchar(50),
	SDT char(11),
	GIOITINH nchar(5) check (GIOITINH = N'Nữ' or GIOITINH = N'Nam'),
	NGAYSINH date,
	DIACHI nvarchar(150),
);

create table NHACUNGCAP(
	MANCC int identity(1,1) primary key,
	TENNCC nvarchar(100),	-- Tên chính thức của công ty hoặc tổ chức cung cấp hàng hóa, dịch vụ cho shop.
	TENLIENHE nvarchar(50),	-- Tên của cá nhân đại diện hoặc người phụ trách việc liên lạc giữa shop và nhà cung cấp.
	EMAIL nvarchar(50),
	SDT nvarchar(20),
	DIACHI nvarchar(150),
);

create table DONHANG(
	MADH int identity(1,1) primary key,
	NGAYDAT date default getdate(),
	TONGTIEN money,
	TRANGTHAI nvarchar(30),
	MAKH int,
	MANV int,
	constraint FK_DONHANG_KHACHHANG foreign key (MAKH) references KHACHHANG(MAKH),
	constraint FK_DONHANG_NHANVIEN foreign key (MANV) references NHANVIEN(MANV)
);

create table CHITIETDONHANG(
	MADH int NOT NULL,
	MASP int NOT NULL,
	SOLUONG int,
	DONGIA money,
	constraint PK_CHITIETDONHANG primary key (MADH, MASP),
	constraint FK_CHITIETDONHANG_DONHANG foreign key (MADH) references DONHANG(MADH),
	constraint FK_CHITIETDONHANG_SANPHAM foreign key (MASP) references SANPHAM(MASP),
);

create table PHIEUNHAP
(
	MAPN int identity(1,1) primary key,
	MANCC int,
	MANV int,
	NGAYNHAP date default getdate(),
	TONGGIATRI money,
	GHICHU nvarchar(MAX),
	constraint FK_PHIEUNHAP_NHACUNGCAP foreign key (MANCC) references NHACUNGCAP(MANCC),
	constraint FK_PHIEUNHAP_NHANVIEN foreign key (MANV) references NHANVIEN(MANV)
);

create table CHITIETPHIEUNHAP
(
	MAPN int NOT NULL,
	MASP int NOT NULL,
	SOLUONG int,
	DONGIA money,
	constraint PK_CHITIETPHIEUNHAP primary key (MAPN, MASP),
	constraint FK_CHITIETPHIEUNHAP_PHIEUNHAP foreign key (MAPN) references PHIEUNHAP(MAPN),
	constraint FK_CHITIETPHIEUNHAP_SANPHAM foreign key (MASP) references SANPHAM(MASP)
);

set dateformat DMY
insert into LOAI
values
(N'SỮA CÁC LOẠI'),
(N'BÁNH KẸO CÁC LOẠI'),
(N'CHĂM SÓC CÁ NHÂN'),
(N'SẢN PHẨM CHO MẸ VÀ BÉ'),
(N'VỆ SINH NHÀ CỬA'),
(N'ĐỒ DÙNG GIA ĐÌNH');
insert into PHANLOAI
values
(N'Sữa tươi', 1),
(N'Sữa bột', 1),
(N'Sữa chua', 1),
(N'Bánh quy', 2),
(N'Kẹo singum ', 2),
(N'Các loại hạt, trái cây khô', 2),
(N'Dầu gội, Dầu xả', 3),
(N'Các loại kem , keo', 3),---Kem cạo râu , keo vuốt tóc, kem ủ tóc, kem duongx da,....
(N'Sữa rữa mặt', 3),
(N'Sữa tắm, Dầu gội cho bé ',4),
(N'Nước xả, nước giặt cho bé', 4),
(N'Đồ dùng cho bé', 4),--Phấn thơm , kem đánh răng , bàn chải , bình sửa,....
(N'Nước giặt, nước xả', 5),
(N'Nước lau sàn, rửa chén ', 5),
(N'Xịt phòng, Xáp thơm', 5),
(N'Đồ dùng một lần', 6),
(N'Hộp đựng thực phẩm', 6),
(N'Màng bọc, giấy thấm dầu', 6);
insert into SANPHAM (TENSP, THUONGHIEU, GIA, MOTA, HINHANH, TONKHO, MAPHANLOAI)
values
--DM1 , SỮA TƯƠI
(N'Sữa tươi tiệt trùng có đường TH true MILK',N'TH true MILK ',10000,N'Sữa tươi TH True Milk đảm bảo không sử dụng thêm hương liệu, mang vị ngon sữa tươi nguyên chất 100%, chứa nhiều vitamin và khoáng chất như Vitamin A, D, B1, B2, canxi, kẽm. Sữa tươi tiệt trùng có đường TH true MILK hộp 1 lít đóng hộp lớn tiện lợi, tiết kiệm.','suahopTH.jpg',150,1),
(N'Sữa tiệt trùng hương dâu Dutch Lady bịch 180ml',N'Dutch Lady',7200,N'Sữa tiệt trùng hương dâu Dutch Lady bịch 180ml bổ dung đầy đủ dinh đưỡng cho bữa sáng. Sữa tươi Dutch Lady là nhãn hiệu sữa tươi chất lượng, không chứa chất bảo quản, với nhiều hương vị thơm ngon, hấp dẫn.','suabicDL.png',200,1),
(N'Sữa tươi tiệt trùng có đường Dalat Milk 180ml',N'Dalat Milk',7000,N'Sữa tươi tiệt trùng Dalat Milk có đường làm từ nguồn sữa bò tươi 100% và được sản xuất bởi Công ty cổ phần sữa Đà Lạt. Dalat Milk là nhãn hiệu sữa được thành lập năm 2009 với tiền thân là Nông trường Bò sữa Lâm Đồng, vào năm 2014, Dalat Milk đã được mua lại bởi tập đoàn TH với thương hiệu sữa tươi sạch TH True Milk hàng đầu tại Việt Nam.','suahopDLat.jpg',140,1),
(N'Sữa dinh dưỡng tiệt trùng có đường Nuvi 180ml',N'Nuvi Milk',5500,N'Thành phần dinh dưỡng có trong sữa dinh dưỡng tiệt trùng Nuvi 180ml: Chất đạm, chất béo, cacbonhydrat cùng các vitamin và khoáng chất như: Niacin, canxi, phospho, vitamin D3, lysine, kẽm, taurine, sắt, vitamin A, B2, B1, B6,...Trong 100ml sữa dinh dưỡng Nuvi có chứa khoảng 82 calo.','suaNuvi.jpg',100,1),
(N'Sữa tươi thanh trùng có đường Lothamilk chai 880ml',N'Lothamilk',42000,N'Sữa tươi thanh trùng Lothamilk là nhãn hiệu sữa tươi chủ lực của công ty cổ phần Lothamilk, được thành lập vào 12/8 năm 1997.Các sản phẩm sữa tươi mang thương hiệu Lothamilk rất được ưa chuộng trên thị trường bởi hương vị sữa tươi chính gốc, cùng công nghệ sản xuất hiện đại chuẩn Châu Âu với bí quyết truyền thống của riêng Lothamilk.Thành phần dinh dưỡng trong sữa tươi thanh trùng Lothamilk có đường 880ml.Sữa tươi thanh trùng Lothamilk với ưu điểm xử lý ở mức nhiệt thấp đủ để loại trừ vi khuẩn gây hại, song song với đó vẫn giữ được hầu như nguyên bản giá trị của sữa tươi tự nhiên.','sualotha.jpg',240,1),
--DM2 , SỬA BỘT
(N'Sữa Grow Plus Vàng Sữa Non 0+ 800G (0-12 tháng)',N'NutiFood',480000,N'Sữa Grow Plus sữa non (Vàng) với công thức được phát triển bởi Viện nghiên cứu dinh dưỡng Nutifood Thụy Điển (NNRIS), xây dựng nền tảng FDI Đề kháng khỏe, tiêu hóa tốt giúp trẻ hấp thu tối ưu các dưỡng chất. Sản phẩm được bổ sung 100% sữa non 24h tự nhiên từ Mỹ cùng 2′-FL HMO giúp tăng cường hệ miễn dịch, tạo nền tảng vững chắc cho bé cao lớn và thông minh hơn.','suanutifood.jpg',294,2),
(N'Sữa Enplus Gold 900g (người cao tuổi, người ốm)',N'NutiFood',480000,N'Sữa Enplus Gold giải pháp dinh dưỡng cho người cao tuổi, người bệnh, người ăn uống kém.Thử nghiệm lâm sàng đã chứng minh EnPlus Gold là sản phẩm tốt cho người cao tuổi người bệnh, người ăn uống kém, giúp nâng cao tình trạng dinh dưỡng và vi chất dinh dưỡng.EnPlus Gold giàu năng lượng (1ml cung cấp 1kcal) và giàu duỡng chất, đặc biệt thích hợp cho nuôi ăn qua ống thông dạ dày trong bệnh viện, cho người bệnh, người có nhu cầu dinh dưỡng cao nhưng ăn uống kém.','sua-enplus-gold.jpg',180,2),
(N'Sữa Meta Care Opti 0+ 800g (trẻ từ 0-12 tháng)',N'NUTRICARE',355000,N'Sữa Meta Care Opti 0+ cung cấp năng lượng, đạm Whey và các vi chất dinh duwognx phù hợp sinh lý lứa tuổi và hệ tiêu hóa non nớt của bé.Mẹ có biết, hệ tiêu hóa khỏe mạnh là nền tảng để bé hấp thu tốt các dưỡng chất cần thiết? Meta Care Opti 0+ giàu đạm Whey, kết hợp cùng tinh chất Oliu, HMO (2’FL), chất xơ, lợi khuẩn và các vi chất thiết yếu phù hợp với hệ tiêu hóa của bé.','sua-metacare-opti.jpg',149,2),
(N'Sữa Non ILDONG số 1 Hàn Quốc 90 gói/90g (trẻ 0-12 tháng)',N'ILDONG FOODIS Korea',250000,N'Sữa Non ILDong số 1 giúp tăng cường sức đề kháng tự nhiên cho bé từ 0-12 tháng được các mẹ đánh giá tốt nhất hiện nay.
Sữa non ILDONG là sản phẩm bổ sung rất nhiều dưỡng chất quý, nhân tố tăng trưởng IGF, immunoglobulin IgG, các chất dinh dưỡng tốt cho não. Sử dụng sữa non ILDONG thường xuyên sẽ giúp tạo nền tảng vô cùng vững chắc cho sức khỏe của trẻ được nuôi bằng sữa mẹ hoặc sữa công thức. Ngoài ra, các thành phần protein huyết thanh, canxi sữa, vitamin và khoáng chất sữa non hỗ trợ sự phát triển của răng và xương, đồng thời thúc đẩy quá trình tăng trưởng và phát triển ở các bé.
Sữa non ILDong được các mẹ xem như nguồn dinh dưỡng bổ sung không thể thiếu hàng ngày cho bé giúp tăng cường sức đề kháng, giảm ốm vặt từ đó giúp bé phát triển an toàn khỏe mạnh. Sản phẩm phù hợp với các bé lười ăn, còi xương, chậm lớn, hệ miễn dịch yếu, bé đang ốm hoặc mới ốm dậy cần phục hồi sức khỏe thì mẹ cần phải tham khảo ngay cho con!','sua-non-ildong.jpg',249,2),
(N'Sữa Nepro 1 400g (sữa cho người bệnh thận Ure huyết tăng)',N'VITADAIRY',215000,N'Sữa Nepro 1 dinh dưỡng y học giảm Protein đặc trị cho người bệnh thận có Ure huyết tăng.
Suy thận mạn là một hội chứng bệnh lý tồn tại suốt đời. Bệnh sẽ tiến triển nặng dần nếu không có phác đồ điều trị cụ thể bên cạnh đó chế độ dinh dưỡng của người bệnh phải tuyệt đối tuân theo nguyên tắc: hạn chế lượng protein, đủ năng lượng, đủ vitamin và các yếu tố vi lượng.
Sữa Nepro 1 giúp kiểm soát lượng đạm trong người bệnh thận, giàu chất dinh dưỡng cung cấp đủ năng lượng cho người bệnh.  Ngoài ra sữa chứa ít Natri, Kali, Phospho, tốt cho hệ tiêu hóa và rất thơm ngon dễ uống.
Sản phẩm sử dụng nguồn đạm có giá trị sinh học cao dễ hấp thu, cung cấp đủ 8 loại axit amin cần thiết cho cơ thể. Sử dụng sữa hàng ngày theo chỉ định giúp giảm gánh nặng cho thận, tránh các tổn thương ở tim của người bệnh.
Sữa Nepro 1 hộp 400g có nguyên liệu được nhập khẩu từ Mỹ, công thức y học từ các chuyên gia hàng đầu. Kết hợp với công nghệ sản xuất tiên tiến của Vitadairy cho ra sản phẩm hữu hiệu cho người bệnh suy thận.','sua-nepro-400g.jpg',136,2),
--DM3 --SỮA CHUA
(N'Lốc 4 hộp sữa chua có đường Vinamilk 100g',N'Vinamilk',48000,N'Sản phẩm được làm từ sữa, đường kết hợp cùng một số thành phần khác. Sữa chua chứa nhiều lợi khuẩn tốt cho tiêu hoá và các khoáng chất như kali, canxi, magie, kẽm, selen, vitamin giúp tăng cường hệ miễn dịch. Sữa chua Vinamilk mang đến hàm lượng dinh dưỡng cao cho cơ thể. Với 100g sản phẩm cung cấp 102.6 kcal, cùng với đó là các chất đạm, chất béo, vitamin A, D, canxi cùng nhiều khoáng chất khác.','suachuavinamilk.jpg',127,3),
(N'Lốc 4 hộp sữa chua ăn thanh trùng vị vani Top Kid TH True Yogurt 60g',N'TH True Yogurt',22000,N'Lốc 4 hộp sữa chua ăn thanh trùng TH True Yogurt vị vani Top Kid 60g, dòng sản phẩm sữa chua ăn liền phù hợp cho trẻ nhỏ, làm từ các thành phần: Sữa hoàn toàn từ sữa bò tươi 86%, đường, chất ổn định, khoáng chất, hương vị vani tổng hợp,... Cung cấp đầy đủ các giá trị dinh dưỡng như: Năng lượng, protein, carbohydrate, chất đạm, chất béo, vitamin B6, B12, A,... Theo như thông tin trong 100g sản phẩm sẽ chứa khoảng 105 kcal.','suachuaanTHtrue.png',137,3),
(N'Lốc 4 hộp sữa chua ăn ít đường Nutimilk 100g',N'Nutimilk',16000,N'Sữa chua Nutimilk được làm từ sữa tươi nguyên chất, hương vị thơm ngon, độc đáo, thích hợp cho cả người lớn và trẻ em. Lốc 4 hộp sữa chua ăn ít đường Nutimilk 100g ít đường, tốt cho sức khỏe, chua ngọt thanh vị, có hương vị thơm ngon tự nhiên. Sữa chua cung cấp các dưỡng chất cần thiết cho bạn ngày mới năng động.','suachuaNutiMilk.jpg',139,3),
(N'Lốc 8 hộp sữa chua lên men tự nhiên hương cam YoMost 170ml',N'YoMost',52000,N'Sữa chua uống Yomost là một trong những nhãn hiệu chuyên sản xuất và cung cấp các sản phẩm sữa chua của Dutch Lady thuộc tập đoàn thực phẩm Friesland Campina tại Hà Lan. Friesland Campina hiện đang là doanh nghiệp sản xuất bơ sữa lớn nhất trên thế giới. Hiện tại, Yomost đã trở thành một trong những nhãn hàng sữa chua uống được ưa chuộng hàng đầu tại nhiều quốc gia, trong đó có Việt Nam.
Thành phần dinh dưỡng trong thùng 48 hộp sữa chua uống hương cam YoMost 170ml
Thành phần dinh dưỡng của sữa chua uống Yomost cam bao gồm: Năng lượng, chất đạm, chất béo, carbohydrate, canxi, phốt pho, natri, và các vitamin B1, B2, B3, B6, B12','suachuaYomost.jpg',138,3),
(N'Lốc 6 chai sữa chua uống tiệt trùng hương cam LiF Kun 85ml',N'LiF Kun',27000,N'Thành phần dinh dưỡng trong lốc 6 chai sữa chua uống tiệt trùng hương cam LiF Kun 85ml
Lốc 6 chai sữa chua uống tiệt trùng hương cam LiF Kun 85ml có chứa những thành phần dinh dưỡng như: Năng lượng, chất đạm, carbohydrate, chất béo, vitamin B1, B6, B2, kẽm, lysine,... Trung bình trong 100ml sữa chua uống tiệt trùng hương cam LiF Kun có khoảng 76.6 kcal.','suachuaFifKun.jpg',89,3),
--DM4 --Bánh Quy
(N'Bánh quy kẹp kem phô mai Lexus hộp 150g',N'Lexus',29000,N'Thành phần dinh dưỡng có trong sản phẩm :
Bánh quy Lexus được làm từ các thành phần như: bột mì, đường, bột phô mai, bột sữa, rau sấy khô,.. nên đây sẽ là nguồn cung cấp năng lượng dồi dào cho cơ thể. Ngoài ra bánh còn bổ sung chất đạm, chất béo, natri, đường và một số chất khác cho cơ thể. Lượng calo chứa trong 100g bánh là khoảng 500 kcal, theo thông tin được in trên bao bì.','banhLexus.jpg',130,4),
(N'Bánh quy bơ thập cẩm LU Pháp hộp 540g',N'LU',199000,N'Thành phần dinh dưỡng trong sản phẩm : 
Bánh quy LU hoàn toàn được làm từ những nguyên liệu quen thuộc như: bột mì, đường, bơ Pháp, socola, cacao, vani,... tạo vị thơm béo cực ngon cho bánh. Sản phẩm sẽ cung cấp năng lượng cho cơ thể, bánh còn bổ sung các chất đạm, chất béo, chất xơ, đường,... Theo thông tin được in trên bao bì sản phẩm, trong 100g bánh quy LU cung cấp cho cơ thể khoảng 533 kcal.','banh-quy-bo-lu-hop.jpg',124,4),
(N'Bánh quy bơ Danisa hộp 681g',N'Danisa',201000,N'Danisa là thương hiệu bánh quy nổi tiếng có xuất xứ từ Indonesia mang đậm hương vị bánh quy truyền thống Đan Mạch. Được thành lập và phát triển bởi Tập đoàn Mayora, thương hiệu bánh này luôn được người tiêu dùng tin tưởng lựa chọn bởi chất lượng sản phẩm cao cấp, hương vị bánh đặc biệt và bao bì luôn thu hút người tiêu dùng. 
Bánh quy Danisa được sản xuất từ công thức chính gốc của Đan Mạch, với nguyên liệu được lựa chọn kỹ càng, tinh túy nhất, sử dụng loại bơ thượng hạng giàu hương vị góp phần tạo nên sự khác biệt độc đáo so với các dòng bánh quy bơ khác.','sellingpoint.jpg',176,4),
(N'Bánh quy mè Gouté hộp 288g',N'Gouté',53500,N'Thành phần dinh dưỡng trong sản phẩm :
Bánh quy Gouté được sản xuất từ các nguyên liệu được lựa chọn kỹ càng. Trong bánh quy cung cấp cho cơ thể một lượng năng lượng, ngoài ra bổ sung thêm một số chất khác như chất béo, carbohydrate, chất đạm,... và một số chất khác. Theo thông tin trên được in trên bao bì sản phẩm, trong 100g bánh quy mè chứa khoảng 530 kcal.','banh-quy-me-goute-hop.jpg',341,4),
(N'Bánh cracker phô mai Gery hộp 180g',N'Gery',39000,N'Thành phần dinh dưỡng trong sản phẩm :
Bánh cracker phô mai Gery hộp 180g đây là sản phẩm dạng bánh quy truyền thống, giòn tan, được phủ lớp đường bên trên và có hương thơm từ phô mai nồng nàn khó cưỡng, sản phẩm được làm từ các thành phần: Bột mì, đường, chất béo thực vật, bột sữa thực vật, dầu thực vật (dầu cọ), bột phô mai, bột whey, bột ngô, bột sữa, tinh mạch nha, Dekstrose Monohydrat,... cho sản phẩm thơm ngon tự nhiên và chuẩn vị.
Bên cạnh đó sản phẩm vẫn đáp ứng được các giá trị dinh dưỡng nhất định như: Năng lượng, chất béo, chất đạm, đường, natri,... cần thiết cho cơ thể.','banh-cracker-pho-mai-gery-hop.png',233,4),
--DM5 --Kẹo Singum
(N'Kẹo gum Cool Air Fresh Cube hương chanh hũ 40g',N'Cool Air',31000,N'Thành phần dinh dưỡng trong sản phẩm :
Thành phần dinh dưỡng: Kẹo gum Cool Air Fresh Cube hương chanh được làm từ các nguyên liệu như chất làm ngọt tổng hợp (sorbitol, xylitol), chất điều vị, hương liệu tự nhiên từ chanh và một số phụ gia an toàn khác. Mỗi 2.28g kẹo gum Cool Air Fresh Cube chứa khoảng 4.45 calo, với hàm lượng đường rất thấp, giúp hạn chế lượng calo nạp vào cơ thể mà vẫn mang lại cảm giác ngọt dịu tự nhiên.','keo-gum-cool-air-fresh.png',156,5),
(N'Kẹo gum không đường Lotte Xylitol hương Blueberry Mint hũ 55.1g',N'Lotte Xylitol',27200,N'Thành phần dinh dưỡng trong sản phẩm :
Thành phần: Kẹo gum không đường Lotte Xylitol hương Blueberry Mint chứa các thành phần chính như Chất tạo ngọt Xylitol 39%, Maltitol, Aspartam; Cốt gôm; Hương bạc hà Blueberry giống tự nhiên và tổng hợp,... Trong 100g cung cấp các chất như: Năng lượng: 200 kcal, chất béo, chất đạm, carbohydrate, xylitol,...','keo-gum-lotte-xylitol-huong-blueberry.jpg',153,5),
(N'Kẹo sing-gum DoubleMint hương bạc hà hũ 58.4g',N'DoubleMint ',28800,N'DoubleMint là một thương hiệu nổi tiếng thuộc tập đoàn Wrigley, chuyên sản xuất các loại kẹo gum được yêu thích trên toàn thế giới. Ra đời từ năm 1914, DoubleMint đã khẳng định vị thế của mình qua nhiều thập kỷ với các sản phẩm chất lượng cao, mang lại hương vị tươi mới và sảng khoái cho người tiêu dùng. Kẹo sing-gum DoubleMint hương bạc hà là một trong những sản phẩm đặc trưng của thương hiệu, nổi bật với hương vị bạc hà đặc trưng và cảm giác mát lạnh.','keo-sing-gum-doublemint-huong-bac-ha.png',245,5),
(N'Kẹo sing-gum Cool Air hương bạc hà khuynh diệp hũ 146g',N'Cool Air',45500,N'Đôi nét về thương hiệu Cool Air
Kẹo sing gum Cool Air hương bạc hà khuynh diệp là một trong những sản phẩm kẹo bán chạy nhất hiện nay.
Cool Air là thương hiệu kẹo cao su được rất nhiều người tiêu dùng trên toàn thế giới ưa chuộng, thuộc Công ty Wrigley thành lập vào năm 1981.
Thành phần dinh dưỡng trong kẹo sing gum Cool Air hương bạc hà khuynh diệp hũ 146g
Kẹo sing gum hay còn được gọi là kẹo cao su, kẹo gum, đây là một dạng kẹo mềm, có đa dạng các vị khác nhau chỉ để nhai mà không được nuốt.
Trong sản phẩm kẹo sing-gum Cool Air hương bạc hà khuynh diệp 58.4g có những thành phần chính như: Đường, chất gum nền, siro glucose, hương bạc hà khuynh diệp,...','keo-sing-gum-cool-air-huong-bac-ha-khuynh-diep.png',232,5),
(N'Kẹo sing-gum Hubba Bubba vị truyền thống hộp 56g',N'Hubba Bubba',51000,N'Kẹo singum được biết đến là một loại kẹo thơm ngon từ kẹo Singum Hubba Bubba, được làm từ gum nền và hương liệu khác mang đến cảm giác vô cùng thích thú khi nhai. Hubba Bubba đã ngay lập tức chiều lòng khách hàng bằng những sản phẩm kẹo singum có hương vị đa dạng. Sản phẩm Kẹo sing-gum Hubba Bubba vị truyền thống hộp 56g là một trong những sản phẩm được yêu thích hiện nay.','keo-sing-gum-hubba-bubba-vi-truyen-thong-hop.jpg',243,5),
--DM6--Các loại hạt, trái cây khô
(N'Đậu phộng tỏi ớt Tân Tân hũ 260g',N'Tân Tân',70000,N'Thành phần dinh dưỡng trong sản phẩm :
Sản phẩm sử dụng thành phần đậu phộng được tẩm ướp gia vị vừa ăn, hạt đậu vẫn giữ được độ giòn thơm hấp dẫn. Đây sẽ nguồn năng lượng dồi dào cho cơ thể. Ngoài ra đậu phộng tỏi ớt cũng giúp bổ sung chất đạm, chất béo, carbohydrate, canxi và một số chất khác cho cơ thể. Theo thông tin được in trên bao bì sản phẩm, trung bình trong 100g sản phẩm sẽ cung cấp khoảng 607 kcal cho cơ thể.','dau-phong-toi-ot-tan-tan.png',152,6),
(N'Hạt hướng dương vị ngũ vị hương Chacheer gói 130g',N'Chacheer',26000,N'Đôi nét về thương hiệu 
Chacheer là thương hiệu hạt hướng dương nổi tiếng có nguồn gốc xuất xứ tại Thái Lan được nhiều người Việt lựa chọn tin dùng. Nhập khẩ sang thị trường Việt Nam thương hiệu Chacheer càng khẳng định được vị thế của mình trên thị trường và ngày càng được nhiều người yêu thích bởi cho ra mắt các sản phẩm chất lượng, an toàn sức khỏe người sử dụng. 
Thành phần dinh dưỡng :
Hạt hướng dương ngũ Chacheer 130g có chứa các thành phần như sau: Hạt hướng dương (93,7%), muối, gia vị (cam thảo, thì là), chất tạo ngọt tổng hợp, hương ngũ vị hương tổng hợp','hat-huong-duong-vi-ngu-vi-huong-chacheer.jpg',322,6),
(N'Hạt hạnh nhân và bắp nướng Toms Farm gói 40g',N'Toms Farm',55000,N'Thành phần dinh dưỡng trong sản phẩm
Thành phần của hạt hạnh nhân và bắp nướng Toms Farm bao gồm: Hạt hạnh nhân Mỹ, bắp Úc, đường, xi rô tinh bột, gia vị bắp tổng hợp,.... Hạt hạnh nhân giàu chất béo tốt, protein, vitamin E và các khoáng chất như magie, canxi, trong khi bắp cung cấp chất xơ và tinh bột. Trong 40g sản phẩm, hạt hạnh nhân và bắp nướng cung cấp khoảng 194 kcal, là nguồn năng lượng dồi dào cho các hoạt động thể chất và trí não.','hat-hanh-nhan-va-bap-nuong-toms-farm.png',452,6),
(N'Khoai lang vàng sấy Rộp Rộp gói 100g',N'Rộp Rộp ',26000,N'Rộp Rộp là thương hiệu trái cây sấy nổi tiếng có xuất xứ tại Việt Nam, thương hiệu này hiện có nhiều dòng sản phẩm trái cây, rau củ sấy với nhiều hương vị hấp dẫn, thơm ngon. Rộp Rộp có dây chuyền công nghệ hiện đại, nguồn nguyên liệu tươi ngon tạo nên nhiều loại sản phẩm đạt chất lượng cao, phù hợp với khẩu vị người tiêu dùng.
Thành phần dinh dưỡng trong sản phẩm :
Khoai lang vàng sấy Rộp Rộp là sản phẩm trái cây sấy thơm ngon với 100% thành phần khoai lang tự nhiên. Sản phẩm sẽ cung cấp năng lượng, các chất đạm, chất xơ, vitamin C, canxi, chất béo cùng một số khoáng chất khác. Theo thông tin được in trên bảng thành phần dinh dưỡng, trong 100g khoai lang vàng sấy sẽ cung cấp khoảng 511 kcal.','khoai-lang-vang-say-rop-rop.png',231,6),
(N'Mít sấy Rộp Rộp gói 250g',N'Rộp Rộp',82000,N'Nhắc đến các thương hiệu trái cây sấy nổi tiếng tại Việt Nam hiện nay, Rộp Rộp có thể nói là thương hiệu được người tiêu dùng yêu thích lựa chọn. Các sản phẩm trái cây sấy của Rộp Rộp không chỉ thơm ngon mà còn đa dạng sản phẩm và an toàn cho sức khỏe người sử dụng. Thành phần từ trái cây, rau củ chọn lọc được sơ chế và chế biến kỹ cùng quá trình đóng gói đảm bảo chất lượng, an toàn cho người tiêu dùng.
Thành phần dinh dưỡng trong sản phẩm :
Mít sấy Rộp Rộp được làm từ thành phần mít kết hợp cùng dầu thực vật tạo nên sản phẩm giòm rụm, thơm ngon. Sản phẩm sẽ cung cấp năng lượng, các chất đạm, chất xơ, vitamin, canxi, chất béo cùng một số khoáng chất khác. Theo thông tin được in trên bảng thành phần dinh dưỡng, trong 250g mít sấy Rộp Rộp cung cấp cho cơ thể khoảng 430 kcal.','mit-say-rop-rop.png',312,6),
(N'Trái cây sấy Rộp Rộp gói 100g',N'Rộp Rộp',26000,N'Rộp rộp là thương hiệu trái cây sấy chất lượng, đa dạng đã và đang được nhiều người biết đến. Rộp rộp với đa dạng các loại trái cây sấy từ mít, chuối, khoai môn, khoai lang,... đến thập cẩm. Hầu hết các sản phẩm trái cây sấy đều được sấy giòn - giúp cho miếng trái cây giòn rụm, cảm giác tan trong miệng nhưng vẫn giữ được vị ngọt tự nhiên của sản phẩm.
Thành phần dinh dưỡng trong sản phẩm :
Thành phần dinh dưỡng trong Trái cây sấy Rộp Rộp gói 100g chứa nhiều khoáng chất và vitamin như vitamin A, vitamin B, vitamin C, vitamin D, sắt, đồng, kẽm, chất xơ, chất béo,... cần thiết cho cơ thể. Trong 100g trái cây sấy Rộp Rộp có khoảng 468 Kcal.','trai-cay-say-rop-rop.png',213,6),
--DM7 --Dầu gội, Dầu xả
(N'Dầu gội Clear 9 thảo dược cổ truyền làm sạch gàu giảm gãy rụng 330ml',N'Clear',85000,N'Đôi nét về thương hiệu 
Nhắc đến các sản phẩm dầu gội trị gàu nổi tiếng thì Clear  - một thương hiệu thuộc Tập đoàn Unilever được người tiêu dùng yêu thích. Các sản phẩm của Clear mang đến hiệu quả hỗ trợ trị gàu, giảm ngứa hiệu quả. Clear không chỉ mang đến những sản phẩm có hiệu quả trị gàu tốt mà còn bổ sung các dưỡng chất giúp chăm sóc mái tóc người dùng mềm mượt, giảm các tình trạng khô xơ và hương thơm dễ chịu.','dau-goi-clear-9-thao-duoc-co-truyen.jpg',50,7),
(N'Dầu gội Clear Men bạc hà mát lạnh 612ml',N'Clear',198000,N'Dầu gội Clear thương hiệu Hà Lan, là dầu gội làm sạch gàu số 1 Việt Nam. Dầu gội Clear Men bạc hà mát lạnh 612ml chứa Taurin và Vitamin B3 giúp làm sạch nhờn mang lại cảm giác mát lạnh sảng khoái, loại bỏ gàu, tấn công gàu, ngăn gàu tái phát	
Công thức đặc biệt dành riêng cho nam giới với Bio Nutrium 10 và bạc hà giúp dưỡng sâu da đầu, ngăn gàu trở lại, đồng thời mang đến cảm giác mát lạnh tốt đỉnh, nuôi dưỡng tóc và da đầu.
Thành phần :
Water, Sodium Laureth Sulfate, Cocamidopropyl Betaine, Dimethiconol, Citric Acid, Menthol, Parfum...',N'dau-goi-clear-men-bac-ha-mat-lanh.jpg',124,7),
(N'Dầu gội Sunsilk Natural dưỡng phục hồi 380ml',N'Sunsilk',86000,N'Dầu gội Sunsilk Natural dưỡng phục hồi 380ml là sản phẩm dầu gội thiên nhiên với thành phần từ dầu dừa thiên nhiên cùng chiết xuất cỏ mực. Dầu gội Sunsilk Natural sẽ bổ sung protein cần thiết cho tóc, hỗ trợ dưỡng ẩm và phục hồi phần tóc hư tổn, giảm tình trạng khô xơ cho mái tóc óng mượt.
Công dụng :
Bổ sung protein cần thiết cho tóc, hỗ trợ nuôi dưỡng và phục hồi phần tóc hư tổn, giảm tình trạng khô xơ cho mái tóc óng mượt trông thấy. Dưỡng ẩm cho tóc mềm mại và bóng khỏe hơn','xsaww1.jpg',134,7),
(N'Dầu xả Sunsilk óng mượt rạng ngời 653ml',N'Sunsilk',135000,N'Dầu xả Sunsilk là thương hiệu thuộc tập đoàn Unilever với các dòng dầu xả chất lượng, được nhiều người tiêu dùng yêu thích. Dầu xả Sunsilk óng mượt rạng ngời 653ml với chiết xuất từ bồ kết, vitamin E, dầu dừa và protein gạo đen giúp nuôi dưỡng mái tóc óng mượt và chắc khoẻ tự nhiên.','dau-xa-sunsilk.jpg',213,6),
(N'Dầu xả Pantene 3 phút diệu kì ngăn rụng tóc 300ml',N'Pantene',106000,N'"Kem Xả Pantene 3MM 3 Phút Diệu Kỳ Ngăn Rụng Tóc"
Đặc điểm nổi bậ
Kem xả collagen 3 phút diệu kỳ siêu dưỡng chất phục hồi tóc hư tổn của Pantene kết hợp sức mạnh của công thức Pro-Vitamin B5 và Biotin nhằm nuôi dưỡng tóc với hiệu quả cao nhất, chống lại tình trạng tóc yếu, tóc gãy rụng do hư tổn.
Ngoài phục hồi hư tổn, dòng dầu xả đậm đặc với serum này còn giúp mái tóc chắc khỏe dài lâu. Biotin cũng được biết đến với khả năng phục hồi độ óng mượt cho mái tóc nhờ năng lượng sản sinh từ chất béo và carbohydrate lành tính. Biotin ngấm vào từng','dau-xa-pantene.jpg',143,6),	
(N'Dầu xả Cruset tinh chất lựu đỏ 1 lít',N'Cruset',325000,N'Dầu gội Cruset tinh chất lựu đỏ 1 lít chiết xuất từ lựu đỏ, dầu xả Cruset kích thích sản sinh collagen, ngăn chặn quá trình oxy hoá tế bào, giúp giảm rụng tóc và hỗ trợ mọc tóc, tạo mái tóc dày và bồng bềnh hơn. Dầu xả còn có hương thơm dễ chịu mang lại cảm giác thư giãn sau khi dùng.','dau-xa-cruset.jpg',134,6),
---DM12 Đồ dùng cho bé
(N'Phấn thơm trẻ em Babi Mild White Sakura 180g',N'Babi Mild',32500,N'Babi Mild là thương hiệu chuyên cung cấp các sản phẩm dành cho bé được nhiều mẹ bỉm lựa chọn sử dụng. Babi Mild gia nhập vào thị tường vào năm 2019 và cho đến hiện tại nó được mở rộng ra thị trường bởi cung cấp các sản phẩm chất lượng và đáp ứng được nhu cầu sử dụng của người như: phấn thơm, dưỡng ẩm, khăn giấy,... Với dây chuyên sản xuất hiện đại cùng với các thành phần lành tính, an toàn cho người sử dụng.','phan-thom-babi-mild-white-sakura.jpg',123,12),
(N'Bàn chải cho bé trên 3 tuổi Oral-Clean Formula-1 lông mềm',N'Oral-Clean',52000,N'Bàn chải cho bé được làm bằng chất liệu cao cấp đến từ thương hiệu bàn chải cho bé Oral-Clean, Thái Lan. Bàn chải cho bé trên 2 tuổi Oral-Clean Formula-1 có lông mềm giúp bé dễ dàng chải sạch các mảng bám trên răng. Thiết kế tay cầm với hình dáng xe đáng yêu, bé dễ cầm nắm.','ban-chai-danh-rang-oral-clean.jpg',124,12),
(N'Tã quần bơi em bé cao cấp Aiwibi',N'Aiwibi',18000,N'Tã quần bơi cao cấp Aiwibi là thương hiệu tã, bỉm cho bé chất lượng được nhiều bà mẹ lựa chọn sử dụng bé bé. Tã quần bơi em bé cao cấp Aiwibi size M với hoạ tiết đáng yêu và thời thượng. Tã quần bơi được thiết kế bởi đai co dưới hỗ trợ hiệu quả cho quần bơi, ngăn ngừa tư thế chân cong.​','ta-quan-boi-em-be.jpg',143,12),
(N'Kem đánh răng cho bé từ 6 - 9 tuổi Colgate hương dâu bạc hà 80g',N'Colgate',44000,N'Ra mắt tại Việt Nam từ năm 1998, Colgate-Palmolive Việt Nam đang phân phối đa dạng các dòng sản phẩm bàn chải Colgate, kem đánh răng Colgate, nước súc miệng Colgate Plax, sữa tắm Palmolive và Protex, dầu gội Palmolive, nước rửa tay Protex, sữa tắm và phấn rôm Care dành cho bé... Với xu hướng sản phẩm có nguồn gốc từ thiên nhiên, an toàn, diệt khuẩn,... chăm sóc và bảo vệ toàn diện sức khỏe gia đình, Colgate-Palmolive đã và đang chinh phục trái tim của nhiều gia đình hiện đại.','kem-danh-rang-cho-be.jpg',130,12),
(N'Tắm gội toàn thân cho bé Pigeon chiết xuất jojoba',N'Pigeon',240000,N'Tắm gội cho bé Pigeon với hương thơm dịu nhẹ, không làm hại đến làn da mỏng manh của bé. Tắm gội cho bé giúp bé yêu luôn sạch sẽ, thơm tho, dưỡng ẩm, ngừa rôm sẩy. Tắm gội toàn thân cho bé Pigeon chiết xuất Jojoba 700ml nuôi dưỡng tóc và làn da nhạy cảm của bé trở nên khỏe mạnh và mịn màng','tam-goi-toan-than-cho-be-pigeon-chiet-xuat.jpg',133,12),
---DM13 Nước giặt , nước xả
(N'Nước giặt OMO Matic Comfort cửa trên tinh dầu nước hoa tinh tế túi 4.1kg',N'OMO',215000,N'Nước giặt OMO Matic Comfort cửa trên hương tinh dầu nước hoa tinh tế túi 4.1kg với hương thơm nước hoa tinh tế, sang trọng cùng công thức lưu hương của nước giặt OMO, giúp quần áo thơm mát, dễ chịu kéo dài đến 72 giờ sau khi giặt. Nước giặt OMO với hoạt chất làm sạch từ gốc thực vật, giúp loại bỏ vết ố vàng, bùn đất, thức ăn dính trên áo quấn ngay lần giặt đầu tiên.','nuoc-giat-omo-matic.jpg',124,13),
(N'Nước xả vải Comfort đậm đặc hương nước hoa thiên nhiên diệu kỳ túi 3.1 lít',N'Comfort',181000,N'Nước xả vải Comfort hương nước hoa thiên nhiên diệu kỳ túi 3.1 lít, sản phẩm với những ưu điểm nổi bật:
Nước xả vải với hương nước hoa thiên nhiên diệu kỳ, loại đậm đặc lưu hương suốt 48h cho hương hoa thư giãn, dễ chịu.
Công thức đặc biệt giúp giữ vải bền đẹp không bị cũ sau mỗi lần xả. Cùng 6 lợi ích chăm sóc chuyên sâu. Giúp giảm lượng rác thải quần áo cũ ra môi trường.
Túi nước xả có tay xách và nắp vặn tiện lợi, dung tích rất lớn, dùng lâu dài và tiết kiệm chi phí.','nuoc-xa-vai-comfort.png',102,13),
(N'Nước rửa chén Lix siêu đậm đặc tinh chất trà xanh can 1.37 lít',N'Lix',30000,N'Nước rửa chén Lix Vitamin E được Lixco đầu tư mạnh mẽ về công nghệ và khâu quy trình sản xuất tiên tiến từ Nhật Bản. Từ đó, sản phẩm giúp tẩy sạch các vết dầu mỡ, cùng khả năng đánh bay mùi hôi vượt trội từ thức ăn, mang đến hương trà xanh thơm mát và dịu nhẹ. Đặc biệt, nước rửa chén còn được chiết xuất lô hội kết hợp công thức vitamin E, giúp bảo vệ an toàn da tay người dùng trong suốt quá trình sử dụng.','nuoc-rua-chen-lix-vitamin-e.jpg',124,13),
(N'Nước lau sàn Sunlight tinh dầu thảo mộc hương hoa hạ và bạc hà túi 3.6kg',N'Sunlight',68000,N'Với chiết xuất tinh dầu thiên nhiên, nước lau nhà Sunlight có công thức làm sạch độc đáo, sử dụng hiệu quả với hầu hết mọi bề mặt sàn nhà bởi tính năng phân hủy sinh học và không chứa độc tố, đã được kiểm nghiệm và chứng nhận an toàn cho da bởi Viện Da Liễu Trung Ương, không lo gây hại cho sức khỏe trẻ nhỏ.Với hoạt chất tẩy rửa năng động cùng công thức tiên tiến, nước lau nhà Sunlight còn hạn chế bám bụi trở lại, không để lại cảm giác dính chân, có thể đuổi côn trùng, không có hại cho sức khỏe của bạn.','nuoc-lau-san-sunlight.jpg',223,13),
(N'Sáp thơm Ambi Pur Hương hoa hồng 180g',N'Ambi Pur',63500,N'Khử sạch mùi hôi gây khó chịu
Sáp thơm Ambi Pur hương hoa hồng 180g là sản phẩm hữu hiệu giúp bạn đánh bay những mùi hôi khó chịu do ẩm mốc, mùi thức ăn, hay những mùi hôi khác mà bạn phải chịu đựng trong không gian nhà bạn. Sáp thơm giúp khử sạch hoàn toàn mùi hôi và trả lại bầu không khí trong lành, thoáng mát cho gia đình bạn.
Hương thơm hoa hồng thơm ngát, dễ chịu
Sáp thơm Ambi Pur với thành phần hương thơm hoa hồng tự nhiên, thơm ngát, hấp dẫn, mang đến cảm giác thoải mái, giúp nhanh chóng xóa tan mệt mỏi và dễ chịu cho người sử dụng. Ngoài ra, hương thơm hoa hồng đặc trưng của dòng sản phẩm sáp thơm này còn có thể giúp xua đuổi những côn trùng nhỏ.','sap-thom-ambi-pur-huong-hoa-hong.jpg',145,13),
---DM16 
(N'Bộ 10 hộp thực phẩm nhựa PP chữ nhật Kokusai 1000ml',N'Kokusai',65000,N'Hộp đựng thực phẩm Kokusai là 1 trong những sản phẩm hộp thực phẩm rất thịnh hành tại Việt Nam. Bộ 10 hộp thực phẩm nhựa PP chữ nhật Kokusai 1000ml với công nghệ Nhật Bnar cùng với tính tiện dụng, công dụng nổi bật, bền đẹp và an toàn, đựng được đa dạng loại thực phẩm.','frame.jpg',214,16),
(N'Bộ 17 hộp thực phẩm nhựa chữ nhật Biohome',N'Biohome',79000,N'Hộp đựng thực phẩm Biohome là thương hiệu hộp đựng thực phẩm uy tín, đa dạng kiểu dáng, chất lượng, tha hồ cho bạn chọn lựa. Bộ 17 hộp thực phẩm nhựa chữ nhật Biohome với 6 mức dung tích khác nhau cũng như đa dạng kiểu dáng, linh hoạt sử dụng, chất liệu dày dặn chịu nhiệt tốt.','bo-17-hop-thuc-pham-nhua.jpg',313,16),
(N'Gói 2 miếng cọ nồi cước inox nén Samran IN2 25g',N'Samran',19500,N'Gói 2 miếng cọ nồi cước inox nén Samran IN2 25g là một sản phẩm vô cùng tiện ích trong việc làm sạch nhà bếp. Sản phẩm được sản xuất tại Việt Nam với chất liệu chính là thép không rỉ, đảm bảo độ bền và sự an toàn cho sức khỏe của người sử dụng.
Với công dụng làm sạch, cọ nồi cước inox nén Samran IN2 25g giúp loại bỏ mọi vết bẩn cứng đầu trên nồi, chảo nhôm và các dụng cụ nhà bếp khác một cách nhanh chóng và hiệu quả. Với trọng lượng chỉ 25g/miếng, sản phẩm này rất tiện lợi và dễ dàng mang theo khi cần sử dụng.','sellingpoint.jpg',224,16),
(N'3 cuộn túi đựng rác đen hạt nhựa tái sinh Biohome 55x65cm (1kg)',N'Biohome',56000,N'Được sản xuất từ chất liệu nhựa HDPE, giữa các túi rác Biohome có gân sọc dễ dàng xé, tách túi rác mỗi khi muốn sử dụng, dễ dàng nhanh chóng. 3 cuộn túi đựng rác đen Biohome 55x65cm (1kg) thích hợp sử dụng đựng rác thải, thức ăn thừa không sử dụng, thành phần hạt nhựa tái sinh an toàn cho thiên nhiên, môi trường','tui-dung-rac.jpg',313,16),
(N'Màng bọc thực phẩm PVC Las Palms 30cm x 150m',N'Las Palms',110000,N'Màng bọc thực phẩm Las Palms 30cm x 150m được làm từ nhựa PVC, có màu trắng trong suốt, dẻo dai, không chứa chất độc hại, đảm bảo an toàn khi tiếp xúc với thực phẩm.Màng bọc có độ bám dính tốt trên nhiều chất liệu: nhựa, thuỷ tinh, inox, sứ,... giúp bảo quản thực phẩm tươi ngon, tránh bụi bẩn hoặc vi khuẩn bám vào thức ăn. Hộp được trang bị dao cắt, thuận tiện khi sử dụng và tăng tính an toàn cho người dùng. Màng bọc có thể dùng an toàn trong tủ lạnh và lò vi sóng.','mang-boc-thuc-pham-pvc-las-palms.jpg',113,16);
insert into NHANVIEN (TENNV, SDT, GIOITINH, NGAYSINH, DIACHI, HINHANH)
values
(N'Đinh Nhật Tấn', '0371224525', N'Nam', '25/10/2001', N'Tân Phú', 'hinhanh1.jpg'),
(N'Đặng Gia Bảo', '0351220359', N'Nam', '23/06/2004', N'Tân Bình', 'hinhanh2.jpg'),
(N'Nguyễn Gia Cát', '0371220750', N'Nam', '01/01/2004', N'Tân Phú', 'hinhanh3.jpg'),
(N'Nguyễn Quốc Tú', '0371220734', N'Nam', '01/01/2004', N'Tân Phú', 'hinhanh4.jpg');
insert into PHANQUYEN
values
(1,N'Quản lý'),
(2,N'Nhân viên');
insert into TAIKHOAN (TAIKHOAN, MATKHAU, MANV, ID_ROLE)
values
('rongthan16','881881',1,2),
('giabao','123',1,2),
('quoctudu','123',1,2),
('nhattan','1',1,2);
insert into KHACHHANG (TENKH, EMAIL, SDT, GIOITINH, NGAYSINH, DIACHI)
values
(N'Thanh Tuấn','vd@gmail.com','0123456789',N'Nam','12/12/1999',N'Quận 1'),
(N'Thanh Mai',NULL,'0123456789',N'Nữ','24/03/2006',N'Quận 2'),
(N'Gia Cát','vd@gmail.com',NULL,N'Nam','09/08/2002',N'Quận 3'),
(N'Thu Cẩm','vd@gmail.com','0123456789',N'Nữ','29/02/2004',N'Quận 4'),
(N'Nhật Tấn',NULL,NULL,N'Nam','16/06/1998',N'Quận 5');
insert into NHACUNGCAP (TENNCC, TENLIENHE, EMAIL, SDT, DIACHI)
values
(N'Nhà cung cấp Sữa',N'Tập Đoàn Sữa TH TrueMilk','vd@gmail.com','0123456789',N'Đồng Nai'),
(N'Nhà cung cấp Bánh Kẹo',N'Tập Đoàn Bánh Kẹo Kinh Đô','vd@gmail.com','0123456789',N'Long An'),
(N'Nhà cung cấp Đồ dùng cá nhân',N'Tập Đoàn Unilever ','vd@gmail.com','0123456789',N'Hà Nội'),
(N'Nhà cung cấp Đồ dùng em bé',N'Tập Đoàn Colgate','vd@gmail.com','0123456789',N'Bắc Giang'),
(N'Nhà cung cấp Vệ sinh nhà cửa',N'Tập Đoàn Sunlight','vd@gmail.com','0123456789',N'Dak Nông'),
(N'Nhà cung cấp Đồ dùng gia đình',N'Tập Đoàn Las Palms','vd@gmail.com','0123456789',N'Dak Nông');
insert into DONHANG (NGAYDAT, TONGTIEN, TRANGTHAI, MAKH, MANV)
values
('01/10/2024', 3500000, N'Đã giao', 1, 1),
('05/10/2024', 1500000, N'Đang xử lý', 2, 3),
('10/10/2024', 2000000, N'Đã giao', 3, 2),
('12/10/2024', 500000, N'Đã hủy', 4, 2),
('15/10/2024', 2800000, N'Đang xử lý', 5, 1);
insert into CHITIETDONHANG (MADH, MASP, SOLUONG, DONGIA)
values
(1, 1, 2, 1750000),
(1, 2, 1, 1200000),
(2, 3, 3, 500000),
(2, 4, 2, 250000),
(3, 5, 1, 2000000),
(3, 6, 1, 300000),
(4, 7, 2, 250000),
(4, 8, 1, 500000),
(5, 9, 3, 900000),
(5, 10, 2, 700000),
(5, 11, 1, 1200000);
insert into PHIEUNHAP (MANCC, MANV, NGAYNHAP, TONGGIATRI, GHICHU)
values
(1, 3, '02/10/2024', 5000000, N'Nhập hàng lần 1'),
(2, 3, '06/10/2024', 3000000, N'Nhập hàng lần 2'),
(3, 2, '08/10/2024', 2000000, N'Nhập hàng lần 3'),
(4, 1, '12/10/2024', 1500000, N'Nhập hàng lần 4'),
(5, 1, '14/10/2024', 4000000, N'Nhập hàng lần 5');
insert into CHITIETPHIEUNHAP (MAPN, MASP, SOLUONG, DONGIA)
values
(1, 1, 10, 500000),
(1, 2, 5, 1000000),
(2, 3, 8, 400000),
(2, 4, 12, 250000),
(3, 5, 6, 500000),
(3, 6, 4, 300000),
(4, 7, 10, 150000),
(4, 8, 5, 500000),
(5, 9, 8, 900000),
(5, 10, 6, 700000),
(5, 11, 3, 1200000);


