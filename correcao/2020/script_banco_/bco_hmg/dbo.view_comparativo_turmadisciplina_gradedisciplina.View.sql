USE [erp_hmg]
GO
/****** Object:  View [dbo].[view_comparativo_turmadisciplina_gradedisciplina]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_comparativo_turmadisciplina_gradedisciplina]
AS
SELECT        dbo.academico_turmadisciplina.id, dbo.academico_turmadisciplina.disciplina_id, dbo.academico_turmadisciplina.turma_id, dbo.academico_turma.nome, dbo.curriculos_gradedisciplina.disciplina_id AS Expr1, 
                         dbo.curriculos_grade.id AS Expr2, dbo.academico_disciplina.nome AS Expr3
FROM            dbo.academico_turmadisciplina INNER JOIN
                         dbo.academico_turma ON dbo.academico_turmadisciplina.turma_id = dbo.academico_turma.id INNER JOIN
                         dbo.curriculos_grade ON dbo.academico_turma.grade_id = dbo.curriculos_grade.id INNER JOIN
                         dbo.curriculos_gradedisciplina ON dbo.curriculos_grade.id = dbo.curriculos_gradedisciplina.grade_id AND dbo.academico_turmadisciplina.disciplina_id = dbo.curriculos_gradedisciplina.disciplina_id INNER JOIN
                         dbo.academico_disciplina ON dbo.academico_turmadisciplina.disciplina_id = dbo.academico_disciplina.id AND dbo.curriculos_gradedisciplina.disciplina_id = dbo.academico_disciplina.id
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[16] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "academico_turmadisciplina"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 261
               Right = 318
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "academico_turma"
            Begin Extent = 
               Top = 182
               Left = 373
               Bottom = 312
               Right = 569
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "curriculos_grade"
            Begin Extent = 
               Top = 217
               Left = 635
               Bottom = 347
               Right = 831
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "curriculos_gradedisciplina"
            Begin Extent = 
               Top = 12
               Left = 954
               Bottom = 259
               Right = 1216
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "academico_disciplina"
            Begin Extent = 
               Top = 18
               Left = 547
               Bottom = 148
               Right = 756
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 3105
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin Colu' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_comparativo_turmadisciplina_gradedisciplina'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'mnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_comparativo_turmadisciplina_gradedisciplina'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_comparativo_turmadisciplina_gradedisciplina'
GO
